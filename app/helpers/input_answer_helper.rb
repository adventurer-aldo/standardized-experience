module InputAnswerHelper
  def show_question(answer)
    res = if answer.question_type == 'formula'
            imprint = answer.question.question.dup
            answer.variables.each do |variable|
              imprint[imprint.index('#£')..imprint.index('§')] = variable
            end
            imprint
          else
            answer.question.question
          end
    markdown(res).html_safe
  end

  def input_answer(answer)
    input = %(<input name="answer[#{answer.id}][]" class="form-control form-control-lg" style="font-family: 'Homemade Apple', cursive;color: blue;" placeholder="" aria-label=".form-control-lg example">)
    case answer.question_type
    when 'open', 'formula' # When the answer is to be typed in
      return input.html_safe
    when 'choice', 'multichoice', 'veracity' # When the answer is to be chosen from a list of choices
      options = map_with_decoys(answer.variables)
      case answer.question_type
      when 'choice' # When the answer is a single choice from a list of choices
        options.map do |option|
          %(
          <div class="form-check">
            <input class="form-check-input" type="#{answer.choices.where(veracity: 1).size > 1 ? 'checkbox' : 'radio'}" value="#{option}" name="answer[#{answer.id}][]" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">
              #{option.first}
            </label>
          </div>)
        end.join.html_safe
      when 'veracity' # When the answer follows a true or false rule
        options.map do |option|
          %(
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" role="switch" name="answer[#{answer.id}][]" value="#{option}" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">
              #{option.first}
            </label>
          </div>
        )
        end.join.html_safe
      end
    when 'caption' # When there are multiple answers to be typed in
      answer.question.answer.map do |caption|
        %(<div class="d-flex">#{answer.question.parameters.include?('order') ? %(<div class="position-relative"><span class="position-absolute top-50 start-100 translate-middle badge rounded-pill bg-primary">#{answer.question.answer.index(caption) + 1}</span></div>) : '' } #{input}</div>)
      end.join.html_safe
    when 'table' # When the user must complete a table
      content_tag(:div, answer.question.choices.collect do |choice|
        content_tag(:div, choice.texts.map do |text|
          content_tag(text == '' ? :input : :div, text, class: 'form-control w-100 rounded-0', name: "answer[#{answer.id}][]", style: text == '' ? "font-family: 'Homemade Apple', cursive;color: blue;" : '')
        end.join.html_safe, class: 'd-flex w-100')
      end.join.html_safe, class: 'w-100')
    when 'fill'
      content_tag(:div, answer.choices.first.texts.first.gsub('%s', content_tag(:input, '', name: "answer[#{answer.id}][]", class: 'form-control d-inline-block', style: "max-width: 300px; font-family: 'Homemade Apple', cursive;color: blue;")).html_safe, class: 'mt-1')
    when 'match' # When the user must match two lists
      react_component('QuestionMatch', { id: answer.id, key: answer.id, answers: answer.question.answer.shuffle, choices: answer.variables.map { |variable| Choice.find_by(id: variable.to_i).texts.first } })
    end
  end

  def organize_variables(answer)
    answer.map_with_decoys.map do |choice|
      choice[0]
    end
  end
end
