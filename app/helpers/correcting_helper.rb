module CorrectingHelper

  def grade(quiz, text = false)
    total = 0.0
    answers = quiz.answers
    answers.each do |answer|
      total += answer.grade if answer.correct?
    end
    if text == true
      total.round(2).to_s.gsub('.', ',')
    else
      total.round(2)
    end
  end

  def show_correct(answer)
    case answer.question_type
    when 'open'
      return %(<div class="form-control form-control-lg"><span class='text-wrap#{answer.correct? ? '' : ' text-decoration-line-through' }' style="text-decoration-color: red !important;font-family: 'Homemade Apple', cursive;color: blue;"><b>R:</b> #{answer.attempt.first}</span>
        #{answer.correct? ? '' : %(<span style="font-family: 'Homemade Apple', cursive;color: red;">#{answer.question.answer.sample}</span>)}</div>).html_safe
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
    when 'choice', 'veracity'
      type = if answer.question_type == 'choice' && answer.question.choices.where(veracity: 1).size == 1
               'radio'
             else
               'checkbox'
             end
      role = answer.question_type == 'veracity' ? ' form-switch" role="switch' : ''

      variables = answer.map_with_decoys.map(&:first)
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
          if answer.question_type == 'veracity'
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
      return %(<div class="form-control form-control-lg"><span class='text-wrap#{correct(answer) ? '' : ' text-decoration-line-through' }' style="text-decoration-color: red !important;font-family: 'Homemade Apple', cursive;color: blue;"><b>R:</b> #{answer.attempt.first}</span>
      #{correct(answer) ? '' : %(<span style="font-family: 'Homemade Apple', cursive;color: red;">#{eval(condition)}</span>)}</div>).html_safe
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
