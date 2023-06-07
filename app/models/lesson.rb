class Lesson < ApplicationRecord
  belongs_to :quiz
  has_one :subject, through: :quiz
  has_many :answers, through: :quiz
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'

  def grade
    case quiz.grade
    when 0..4
      'Terrible'
    when 4..8
      'Bad'
    when 8..12
      'Average'
    when 12..16
      'Good'
    when 16..18
      'Great'
    when 18..20
      'Excellent'
    end
  end
end
