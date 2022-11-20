# Table for the answers for each question in a quiz.
class Answer < ApplicationRecord
  belongs_to :question, foreign_key: 'question_id'
  belongs_to :quiz, foreign_key: 'quiz_id'
  has_many :choices, through: :question

  # For choice and veracity questions, use the variables stored in the variables column
  # to display the choices in that specific order.
  def map_with_decoys
    return [] unless question_type == 'choice'

    variables.map do |id|
      choice = Choice.find_by(id: id.to_i)
      if choice.image.attached?
        [choice.texts[0], choice.image.url]
      else
        [choice.texts[0]]
      end
    end
  end

  def correct?
    case question_type
    when 'open'
      if (attempt.intersect?(question.answer) &&
          question.parameters.include?('strict')
          ) ||
          (attempt.map(&:downcase).intersect?(question.answer.map(&:downcase)) &&
            !question.parameters.include?('strict')
          )
        true
      end
    when 'choice'
      true if attempt.sort == question.answer.sort
    when 'caption'
      if (attempt.sort == question.answer.sort &&
          question.parameters.include?('strict') &&
          !question.parameters.include?('order')
          ) ||
          (attempt.map(&:downcase).sort == question.answer.map(&:downcase).sort &&
          !question.parameters.include?('strict') &&
          !question.parameters.include?('order')
          ) ||
          (attempt.map(&:downcase) == question.answer.map(&:downcase) &&
          !question.parameters.include?('strict') &&
          question.parameters.include?('order')
          ) ||
          (attempt == question.answer &&
          question.parameters.include?('strict') &&
          question.parameters.include?('order')
          )
        true
      end
    when 'veracity'
      true if map_with_decoys.map(&:first).intersection(choices.where(veracity: 1).map(&:texts).map(&:first)).sort == attempt.sort
    when 'formula'
      imprint = begin
                  format(question.answer.first, *variables)
                end
      condition = eval <<-RUBY, binding, __FILE__, __LINE__ + 1
        imprint
      RUBY
      true if eval(condition) == attempt.first
    when 'table', 'fill'
      true if (question.answer.map(&:downcase) == attempt.map(&:downcase) &&
                !question.parameters.include?('strict')) ||
              (question.answer == attempt &&
                question.parameters.include?('strict'))
    when 'match'
      if attempt == variables.map { |variable| question.answer[choices.where(veracity: 0).map(&:id).index(variable.to_i)] }
        true
      end
    end
  end
end
