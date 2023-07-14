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

  def get_empty_table_strings(texts)
    array = []
    texts.each_with_index do |text, index|
      text.each_with_index do |cell, rIndex|
        array.push([index, rIndex]) if cell == ''
      end
    end
    return array
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
      type = if answer.question_type == 'choice' && answer.choices.where(veracity: 1).size == 1
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
      empty_indexes = get_empty_table_strings(answer.choices.map(&:texts))
      content_tag(:div, answer.choices.each_with_index.collect do |choice, index|
        content_tag(:div, choice.texts.each_with_index.map do |text, rIndex|
          content_tag(:div, text == '' ? answer.attempt[empty_indexes.index([index, rIndex])] : text , class: 'form-control w-100 rounded-0', style: text == '' ? "font-family: 'Homemade Apple', cursive;color: blue;" : '')
        end.join.html_safe, class: 'd-flex w-100')
      end.join.html_safe, class: 'w-100 rounded border border-muted overflow-hidden') + (answer.correct? ? '' : content_tag(:div, answer.choices.each_with_index.collect do |choice, index|
        content_tag(:div, choice.texts.each_with_index.map do |text, rIndex|
          content_tag(:div, text == '' ? answer.question.answer[empty_indexes.index([index, rIndex])] : text , class: 'form-control w-100 rounded-0 border-danger', style: text == '' ? "font-family: 'Homemade Apple', cursive;color: red;" : '')
        end.join.html_safe, class: 'd-flex w-100')
      end.join.html_safe, class: 'w-100 mt-2 rounded border border-danger overflow-hidden'))
    when 'fill'
      filler = answer.choices.first.texts.first
      filler_correct = filler.dup
      Array(0...(filler.split('%s').size - 1)).each do |i|
        filler['%s'] = "<span class='text-decoration-underline' style=\"font-family: 'Homemade Apple', cursive;color: blue;\">#{[nil, ''].include?(answer.attempt[i]) ? '_______' : answer.attempt[i]}</span>"
        filler_correct['%s'] = "<span class='text-decoration-underline' style=\"font-family: 'Homemade Apple', cursive;color: red;\">#{answer.question.answer[i]}</span>"
      end
      (content_tag(:div, filler.html_safe, class: answer.correct? ? '' : 'opacity-75') + (answer.correct? ? '' : content_tag(:div, filler_correct.html_safe))).html_safe
    when 'match'
      variables = answer.variables
      real_answers = answer.variables.map { |variable| answer.question.answer[answer.choices.map(&:id).index(variable.to_i)] }
      wrongs = variables.each_with_index.filter { |_variable, index| answer.attempt[index] != real_answers[index] }.map(&:first)
      content_tag(:div, variables.each_with_index.collect do |variable, index|
        text = Choice.find_by(id: variable.to_i).texts.first
        content_tag(:div,
          content_tag(:div, content_tag(:span, answer.attempt[index], class: 'p-2') , class: 'w-100 d-flex align-items-center') +
          content_tag(:button, content_tag(:i, '', class: 'bi bi-arrow-left-right'), disabled: true, class: "btn btn-#{real_answers[index] == answer.attempt[index] ? 'success' : 'danger'} rounded-0") +
          content_tag(:div, content_tag(:span, text, class: "p-2"), class: 'w-100 d-flex align-items-center justify-content-end'),
          class: 'd-flex w-100 border border-muted')
      end.join.html_safe + (wrongs.size > 0 ? wrongs.each_with_index.collect do |variable, index|
        text = Choice.find_by(id: variable.to_i).texts.first
        content_tag(:div,
          content_tag(:div, content_tag(:span, real_answers[index], class: 'p-2 text-danger') , class: 'w-100 d-flex align-items-center') +
          content_tag(:button, content_tag(:i, '', class: 'bi bi-arrow-left-right') ,disabled: true, class: "btn btn-dark rounded-0") +
          content_tag(:div, content_tag(:span, text, class: "p-2 text-danger"), class: 'w-100 d-flex align-items-center justify-content-end'),
          class: 'd-flex w-100 border border-muted')
      end.join.html_safe  : ''), class: 'border border-muted rounded')
    end
  end
end
