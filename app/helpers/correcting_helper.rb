module CorrectingHelper
  
  def correct(answer)
    question = answer.question

    correctness = case question.question_types[answer.question_type]
                  when 'open'
                    if Stat.last.lenient_answer == 1
                      matches = []
                      question.answer.each do |matcher|
                        matches.push(matcher.split(" ").intersection(answer.attempt).size)
                      end
                      return matches.max
                    elsif (answer.attempt.intersect?(question.answer) &&
                        question.parameters.include?('strict')
                      ) ||
                      (answer.attempt.map(&:downcase).intersect?(question.answer.map(&:downcase)) &&
                        !question.parameters.include?('strict')
                      )
                      true
                    end
                  when 'choice', 'multichoice'
                    true if answer.attempt.sort == question.answer.sort
                  when 'caption'
                    if (answer.attempt.sort == question.answer.sort &&
                        question.parameters.include?('strict') &&
                        question.parameters.include?('order') == false
                       ) ||
                       (answer.attempt.map(&:downcase).sort == question.answer.map(&:downcase).sort &&
                        question.parameters.include?('strict') == false &&
                        question.parameters.include?('order') == false
                       ) ||
                       (answer.attempt.map(&:downcase) == question.answer.map(&:downcase) &&
                        question.parameters.include?('strict') == false &&
                        question.parameters.include?('order')
                       ) ||
                       (answer.attempt == question.answer &&
                        question.parameters.include?('strict') &&
                        question.parameters.include?('order')
                       )
                      true
                    end
                  when 'veracity'
                    true if organize_variables_text(answer).intersection(question.answer).sort == answer.attempt.sort
                  when 'formula'
                    imprint = begin
                                format(question.answer.first, *answer.variables)
                  end
                    condition = eval <<-RUBY, binding, __FILE__, __LINE__ + 1
                      imprint
                    RUBY
                    true if eval(condition) == answer.attempt.first
                  when 'table'
                    true if (question.answer.map(&:downcase) == answer.attempt.map(&:downcase) &&
                    question.parameters.include?('strict') == false) ||
                    (question.answer == answer.attempt &&
                      question.parameters.include?('strict'))
                  end
    return correctness
  end

  def grade(quiz)
    total = 0.0
    answers = quiz.answers
    answers.each do |answer|
      total += answer.grade if correct(answer) == true
    end
    total.round(2)
  end

  def show_correct(answer)
    question_type = answer.question.question_types[answer.question_type]
    case answer.question.question_types[answer.question_type]
    when 'open'
      return %(<div class="form-control form-control-lg"><span class='text-wrap#{correct(answer) ? '' : ' text-decoration-line-through' }' style="text-decoration-color: red !important;font-family: 'Homemade Apple', cursive;color: blue;"><b>R:</b> #{answer.attempt.first}</span>
        #{correct(answer) ? '' : %(<span style="font-family: 'Homemade Apple', cursive;color: red;">#{answer.question.answer.sample}</span>)}</div>).html_safe
    when 'caption'
      attempts = answer.attempt.dup
      answers = answer.question.answer.dup

      attempts.delete_if { |x| x == '' }

      if answer.question.parameters.include?('order')
        answers.each_with_index.reverse_each do |solve, index|
          next unless attempts[index]
          if answer.question.parameters.include?('strict')
            answers.delete_at(index) if attempts[index] == solve
          else
            answers.delete_at(index) if attempts[index].downcase == solve.downcase
          end
        end
      else
        answers.each_with_index.reverse_each do |solve, index|
          if answer.question.parameters.include?('strict')
            answers.delete_at(index) if attempts.include?(solve)
          else
            answers.delete_at(index) if attempts.map(&:downcase).include?(solve.downcase)
          end
        end
      end

      attempts.each_with_index.map do |attempt, index|
        %(<div class="d-flex">) +
        if answer.question.parameters.include?('order')
          %(<div class="position-relative"><span class="position-absolute top-50 start-100 translate-middle badge rounded-pill bg-#{answer.question.answer[index].downcase == attempt.downcase ? 'success' : 'danger'}">#{index + 1}</span></div>)
        else
          ''
        end + %(<div class='form-control form-control-lg' style="font-family: 'Homemade Apple', cursive;color: blue;">) +
        if answer.question.parameters.include?('strict')
          %(#{answer.question.answer.include?(attempt) ? '' : '<span class="text-decoration-line-through" style="text-decoration-color: red !important;">'}#{attempt}#{answer.question.answer.include?(attempt) ? '' : '</span>'}<span class='text-danger'> #{answer.question.answer.include?(attempt) ? '✓' : '✗'}</span></div>)
        else
          %(#{answer.question.answer.map(&:downcase).include?(attempt.downcase) ? '' : '<span class="text-decoration-line-through" style="text-decoration-color: red !important;">'}#{attempt}#{answer.question.answer.map(&:downcase).include?(attempt.downcase) ? '' : '</span>'}<span class='text-danger'> #{answer.question.answer.map(&:downcase).include?(attempt.downcase) ? '✓' : '✗'}</span></div>)
        end + %(</div>)
      end.union(answers.map do |solve|
        %(<div class="d-flex">) +
        if answer.question.parameters.include?('order')
          %(<div class="position-relative"><span class="position-absolute top-50 start-100 translate-middle badge rounded-pill bg-danger">#{answer.question.answer.index(solve) + 1}</span></div>)
        else
          ''
        end +
        %(<div class='form-control form-control-lg' style="font-family: 'Homemade Apple', cursive;color: red;">#{solve}</span></div></div>)
      end).join.html_safe
    when 'choice', 'multichoice', 'veracity'
      type = case question_type
             when 'choice'
               'radio'
             when 'multichoice', 'veracity'
               'checkbox'
             end
      role = case question_type
             when 'veracity'
               ' form-switch" role="switch'
             else
               ''
             end
      variables = answer.variables.map do |variable|
        if variable.include? 'a'
          text = answer.question.answer[variable[1..].to_i]
          if answer.question.choices.where(decoy: text).exists?
            text += answer.question.choices.where(decoy: text).first.image.attached? ? %(<br><img src="#{answer.question.choices.where(decoy: text).first.image.url}" class"img-fluid">) : ''
          end
          text
        else
          choice = Choice.find_by(id: variable.to_i)
          if choice.image.attached?
            %(#{choice.decoy}<br><img src="#{choice.image.url}" class="img-fluid">)
          else
            choice.decoy
          end
        end
      end
      return variables.map do |option|
        if answer.question.answer.include?(option) && answer.attempt.include?(option) # Correct and selected
          %(<div class="form-check#{role}">
            <input class="form-check-input bg-success" type="#{type}" name="flex#{type.capitalize}Disabled#{answer.id}-#{variables.index(option)}" id="Check#{answer.id}-#{variables.index(option)}" checked disabled>
            <label class="form-check-label" for="Check#{answer.id}-#{variables.index(option)}">
              #{option}
            </label>
          </div>)
        elsif answer.question.answer.include?(option) && !answer.attempt.include?(option) # Correct but not selected
          %(<div class="form-check#{role}">
            <input class="form-check-input bg-danger" type="#{type}" name="flex#{type.capitalize}Disabled#{answer.id}-#{variables.index(option)}" id="Check#{answer.id}-#{variables.index(option)}" disabled>
            <label class="form-check-label" for="Check#{answer.id}-#{variables.index(option)}">
              #{option}
            </label>
          </div>)
        elsif !answer.question.answer.include?(option) && answer.attempt.include?(option) # Incorrect but selected
          %(<div class="form-check#{role}">
            <input class="form-check-input bg-danger" type="#{type}" name="flex#{type.capitalize}Disabled#{answer.id}-#{variables.index(option)}" id="Check#{answer.id}-#{variables.index(option)}" checked disabled>
            <label class="form-check-label" for="Check#{answer.id}-#{variables.index(option)}">
              #{option}
            </label>
          </div>)
        elsif !answer.attempt.include?(option) && !answer.question.answer.include?(option) # Incorrect and not selected
          if question_type == 'veracity'
            %(<div class="form-check#{role}">
              <input class="form-check-input bg-success" type="#{type}" name="flex#{type.capitalize}Disabled#{answer.id}-#{variables.index(option)}" id="Check#{answer.id}-#{variables.index(option)}" disabled>
              <label class="form-check-label" for="Check#{answer.id}-#{variables.index(option)}">
                #{option}
              </label>
            </div>)
          else
            %(<div class="form-check#{role}">
              <input class="form-check-input" type="#{type}" name="flex#{type.capitalize}Disabled" id="Check#{answer.id}-#{variables.index(option)}" disabled>
              <label class="form-check-label" for="Check#{answer.id}-#{variables.index(option)}">
                #{option}
              </label>
            </div>)
          end
        end
      end.join.html_safe
    when 'formula'
      imprint = begin
                  format(answer.question.answer.first, *answer.variables)
    end
      condition = eval <<-RUBY, binding, __FILE__, __LINE__ + 1
        imprint
      RUBY
      return %(<span class='text-wrap text-primary' style="font-family: 'Homemade Apple', cursive;color: blue;"><b>R:</b> #{answer.attempt}</span>
        #{correct(answer) ? '' : %(<span class="text-danger">#{eval(condition)}</span>)}).html_safe
    when 'table'
      content_tag(:table,
        (content_tag(:thead,
          content_tag(:tr, (answer.attempt.first.split('|').map do |head|
            if head[0] == '?' && head[-1] == '?'
              temp = head.dup
              temp[-1] = ''
              temp[0] = ''
              content_tag(:th, temp, style: "font-family: 'Homemade Apple', cursive;color: blue;")
            else
              content_tag(:th, head)
            end
          end).join.html_safe), class: 'bordering'
        ) +
        content_tag(:tbody,
          answer.attempt[1..].collect do |row|
            content_tag(:tr,
              row.split('|').map do |column|
                if column[0] == '?' && column[-1] == '?'
                  temp = column.dup
                  temp[-1] = ''
                  temp[0] = ''
                  content_tag(:td, temp, style: "font-family: 'Homemade Apple', cursive;color: blue;")
                else
                  content_tag(:td, column)
                end
              end.join.html_safe
            )
          end.join.html_safe, class: 'bordering'
        ))
      ) + (correct(answer) ? '' : content_tag(:table,
        (content_tag(:thead,
          content_tag(:tr, (answer.question.answer.first.split('|').map do |head|
            if head[0] == '?' && head[-1] == '?'
              temp = head.dup
              temp[-1] = ''
              temp[0] = ''
              content_tag(:th, temp, style: "font-family: 'Homemade Apple', cursive;color: red;")
            else
              content_tag(:th, head)
            end
          end).join.html_safe), class: 'bordering-red'
        ) + '<br>'.html_safe +
        content_tag(:tbody,
          answer.question.answer[1..].collect do |row|
            content_tag(:tr,
              row.split('|').map do |column|
                if column[0] == '?' && column[-1] == '?'
                  temp = column.dup
                  temp[-1] = ''
                  temp[0] = ''
                  content_tag(:td, temp, style: "font-family: 'Homemade Apple', cursive;color: red;")
                else
                  content_tag(:td, column)
                end
              end.join.html_safe
            )
          end.join.html_safe, class: 'bordering-red'
        ))
      )
    )
    end
  end
end
