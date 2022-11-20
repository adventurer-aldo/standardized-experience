# Table for the questions for a subject that contains the answers (what must be written at the quiz)
# and all the information pertaining itself.
class Question < ApplicationRecord
  has_one_attached :image
  belongs_to :subject, foreign_key: 'subject_id'
  has_many :answers, foreign_key: 'question_id', dependent: :destroy
  has_many :choices, foreign_key: 'question_id', dependent: :destroy
  has_many :frequencies, class_name: 'Frequency', foreign_key: 'question_id', dependent: :destroy
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'

  def generate_variables(type)
    return [] unless %w[choice veracity formula match formula].include?(type)

    case type
    when 'match'
      choices.where(veracity: 0).map(&:id).map(&:to_s).shuffle
    when 'veracity'
      choices.shuffle.sample(rand(1..choices.size)).map(&:id).map(&:to_s)
    when 'choice'
      variables = choices.where(veracity: 0).order(Arel.sql('RANDOM()')).sample(rand(1..10))
      variables.concat(choices.where(veracity: 1))
      variables.shuffle!
      variables.map(&:id).map(&:to_s)
    when 'formula'
      que = question.dup
      variables = []
      que.count('#').times do
        variables << que[/#£(.*?)§/, 1].to_s.split(',')
        que[que.index('#£')..que.index('§')] = ''
      end
      variables.map do |variable|
        case variable.size
        when 1
          Float(rand(1..(variable.first.to_f))).round(2).to_s
        when 2
          Float(rand(variable.first.to_f..variable.last.to_f)).round.to_s
        when 3
          Float(rand(variable.first..variable.last.to_f)).round(1).to_s
        when 4
          Float(rand(variable.first..variable.last.to_f)).round(2).to_s
        when 5
          Float(rand(variable.first.to_f..variable.last.to_f)).round(3).to_s
        else
          Float(rand(20_000)).round(2).to_s
        end
      end
    end
  end
end
