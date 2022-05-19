module CorrectingHelper
  
  def correct(answer)
    question = Question.find_by(id: answer.question_id)

    case answer.question_type
    when 'open'
      if (answer.attempt.intersect?(question.answer) &&
          question.parameters.include?('strict')
         ) ||
         (answer.attempt.map(&:downcase).intersect?(question.answer.map(&:downcase)) &&
          !question.parameters.include?('strict')
         )
        return true
      end
    when 'choice', 'multichoice'
      return true if answer.attempt.sort == question.answer.sort
    when 'caption'
      if (answer.attempt == question.answer &&
          question.parameters.include?('strict')
         ) ||
         (answer.attempt.map(&:downcase).sort == question.answer.map(&:downcase).sort &&
         !question.parameters.include?('strict')
         )
        return true
      end
    when 'veracity'
      return true if answer.attempt.intersection(question.answer) == answer.attempt
    when 'formula'
      condition = eval <<-RUBY, binding, __FILE__, __LINE__ + 1
      format("#{question.answer}", #{answer.variables.join(', ')})
      RUBY
      return true if condition == answer.attempt.first
    when 'table'
      return true if question.answer == answer.attempt
    end

    false
  end

  def grade(quiz)
    total = 0
    answers = Answer.where(quiz_id: quiz.id)
    answers.each do |answer|
      total += answer.grade if correct(answer) == true
    end
    total
  end

  def show_correct(answer)
    case answer.question_type
    when 'open'
      return %(<span class='text-wrap text-primary'><b>R:</b> #{answer.attempt}</span>
        #{correct(answer) ? '' : %(<span class="text-danger">#{answer.question.answer.sample}</span>)})
    when 'caption'
      return answer.attempt.map do |a|
        "<div class='form-control form-control-lg'>#{answer.question.answer.include?(a) ? '' : '<span class="text-decoration-line-through">'}#{a}#{answer.question.answer.include?(a) ? '' : '</span>'}<span class='text-danger'> #{answer.question.answer.include?(a) ? '✓' : '✗'}</span></div>"
      end.join('<br>')
    when 'choice', 'multichoice'
      type = case answer.question_type
             when 'choice'
               'radio'
             when 'multichoice', 'veracity'
               'checkbox'
             end
      role = case answer.question_type
             when 'veracity'
               ' role="switch"'
             else
               ''
             end
      variables = answer.variables.map do |variable|
        if variable.include? 'a'
          answer.question.answer[variable[1..].to_i]
        else
          Choice.find_by(id: variable.to_i)
        end
      end
      return variables.map do |option|
        if answer.question.answer.include?(option) && answer.attempt.include?(option)
          %(<div class="form-check#{role}">
            <input class="form-check-input bg-success" type="#{type}" name="flex#{type.capitalize}Disabled" id="Check#{answer.id}-#{variables.index(option)}" checked disabled>
            <label class="form-check-label" for="Check#{answer.id}-#{variables.index(option)}">
              #{option}
            </label>
          </div>)
        elsif answer.question.answer.include?(option) && !answer.attempt.include?(option)
          %(<div class="form-check#{role}">
            <input class="form-check-input bg-danger" type="#{type}" name="flex#{type.capitalize}Disabled" id="Check#{answer.id}-#{variables.index(option)}" checked disabled>
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
      end.join('<br>')
    when 'formula'
      condition = eval <<-RUBY, binding, __FILE__, __LINE__ + 1
      format("#{question.answer}", #{answer.variables.join(', ')})
      RUBY
      return %(<span class='text-wrap text-primary'><b>R:</b> #{answer.attempt}</span>
        #{correct(answer) ? '' : %(<span class="text-danger">#{condition}</span>)})
    end
  end
end