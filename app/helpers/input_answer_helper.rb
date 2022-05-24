module InputAnswerHelper

  def input_answer(answer)
    input = %(<input name="answer[#{answer.id}][]" class="form-control form-control-lg" style="font-family: 'Homemade Apple', cursive;color: blue;" placeholder="" aria-label=".form-control-lg example">)
    case answer.question.question_types[answer.question_type]
    when 'open', 'formula'
      return input.html_safe
    when 'choice', 'multichoice', 'veracity'
      options = organize_variables(answer)
      case answer.question.question_types[answer.question_type]
      when 'choice'
        return options.map { |option| %(
          <div class="form-check">
            <input class="form-check-input" type="radio" value="#{option}" name="answer[#{answer.id}][]" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">
              #{option}
            </label>
          </div>)}.join
      when 'multichoice'
        return options.map { |option| %(
          <div class="form-check">
            <input class="form-check-input" type="checkbox" value="#{option}" name="answer[#{answer.id}][]" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">
              #{option}
            </label>
          </div>)}.join
      when 'veracity'
        return options.map { |option| %(
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" role="switch" name="answer[#{answer.id}][]" value="#{option}" id="Check#{answer.id}-#{options.index(option)}">
            <label class="form-check-label" for="Check#{answer.id}-#{options.index(option)}">#{option}</label>
          </div>
        )}.join
      end
    when 'caption'
      return (input * answer.question.answer.size).html_safe
    when 'table'
      content_tag(:table,
        (content_tag(:thead,
          content_tag(:tr, (answer.question.answer.first.split('|').map do |head|
            content_tag(:th, head)
          end).join.html_safe)
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
                    style="width: 100%; height: 100%">).html_safe)
                else
                  content_tag(:td, column)
                end
              end.join.html_safe
            )
          end.join.html_safe
        ))
      )
    end
  end

  def organize_variables(answer)
    answer.variables.map do |id|
      if id.include? 'a'
        answer.question.answer[id[1..-1].to_i]
      else
        choice = Choice.find_by(id: id.to_i)
        if choice.image.attached?
          choice.decoy + %(<br><img src="#{choice.image.url}" class="img-fluid">)
        else
          choice.decoy
        end
      end
    end
  end

end