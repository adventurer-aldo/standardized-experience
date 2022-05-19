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

end