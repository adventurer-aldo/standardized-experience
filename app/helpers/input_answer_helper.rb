module InputAnswerHelper

  def show_question(answer)
    if answer.question.question_types[answer.question_type] == 'formula'
      imprint = answer.question.question.dup
      answer.variables.each do |variable|
        imprint[imprint.index('£')..imprint.index('§')] = variable
      end
    else
      answer.question.question
    end
  end

  def input_answer(answer)
    input = %(<input name="answer[#{answer.id}][]" class="form-control form-control-lg" style="font-family: 'Homemade Apple', cursive;color: blue;" placeholder="" aria-label=".form-control-lg example">)
    case answer.question.question_types[answer.question_type]
    when 'open', 'formula' # When the answer is to be typed in
      return input.html_safe
    when 'choice', 'multichoice', 'veracity' # When the answer is to be chosen from a list of choices
      options = organize_variables(answer)
      case answer.question.question_types[answer.question_type]
      when 'choice' # When the answer is a single choice from a list of choices
        options.map do |option|
          %(
          <div class="form-check">
            <input class="form-check-input" type="radio" value="#{option}" name="answer[#{answer.id}][]" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">
              #{option}
            </label>
          </div>)
        end.join.html_safe
      when 'multichoice' # When the answer is multiple choices from a list of choices
        options.map do |option|
          %(
          <div class="form-check">
            <input class="form-check-input" type="checkbox" value="#{option}" name="answer[#{answer.id}][]" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">
              #{option}
            </label>
          </div>)
        end.join.html_safe
      when 'veracity' # When the answer follows a true or false rule
        options.map do |option|
          %(
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" role="switch" name="answer[#{answer.id}][]" value="#{option}" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">#{option}</label>
          </div>
        )
        end.join.html_safe
      end
    when 'caption' # When there are multiple answers to be typed in
      answer.question.answer.map do |caption|
        %(<div class="d-flex">#{answer.question.parameters.include?('order') ? %(<div class="position-relative"><span class="position-absolute top-50 start-100 translate-middle badge rounded-pill bg-primary">#{answer.question.answer.index(caption) + 1}</span></div>) : '' } #{input}</div>)
      end.join.html_safe
    when 'table' # When the user must complete a table
      content_tag(:table,
        (content_tag(:thead,
          content_tag(:tr, (answer.question.answer.first.split('|').map do |head|
            if head[0] == '?' && head[-1] == '?'
              content_tag(:th,
                %(<input type="text"
                name="answer[#{answer.id}][0][#{answer.question.answer.first.split('|').index(head)}]"
                value=""
                style="width: 100%; height: 100%; border: none;font-family: 'Homemade Apple', cursive;color: blue;">).html_safe)
            else
              content_tag(:th, head)
            end
          end).join.html_safe), class: 'bordering'
        ) +
        content_tag(:tbody,
          answer.question.answer[1..].collect do |row|
            content_tag(:tr,
              row.split('|').map do |column|
                if column[0] == '?' && column[-1] == '?'
                  content_tag(:td,
                    %(<input type="text"
                    name="answer[#{answer.id}][#{answer.question.answer.index(row)}][#{row.split('|').index(column)}]"
                    value=""
                    style="width: 100%; height: 100%; border: none;font-family: 'Homemade Apple', cursive;color: blue;">).html_safe)
                else
                  content_tag(:td, column)
                end
              end.join.html_safe
            )
          end.join.html_safe, class: 'bordering'
        ))
      )
    when 'submit' # When the user must submit a file
      %(<input type="file" name="answer[#{answer.id}])
    end
  end

  def organize_variables(answer)
    answer.variables.map do |id|
      if id.include? 'a'
        text = answer.question.answer[id[1..-1].to_i]
        # Check if there's a choice with decoy that matches text
        if answer.question.choices.find_by(decoy: text)
          choice = answer.question.choices.find_by(decoy: text)
          if choice.image.attached?
            text += %(<br><img src="#{choice.image.url}" class="img-fluid">)
          end
        end
        text
      else
        choice = Choice.find_by(id: id.to_i)
        if choice.image.attached?
          choice.decoy + %(<br><img src="#{choice.image.url}" class="img-fluid">)
        else
          choice.decoy
        end
      end
    end.uniq
  end

  def organize_variables_text(answer)
    answer.variables.map do |id|
      if id.include? 'a'
        answer.question.answer[id[1..-1].to_i]
      else
        Choice.find_by(id: id.to_i).decoy
      end
    end.uniq
  end

end
