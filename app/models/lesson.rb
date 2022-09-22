class Lesson < ApplicationRecord
  belongs_to :quiz
  has_one :subject, through: :quiz
  has_many :answers, through: :quiz
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'

  def grade
    case quiz.grade
    when 0..4
      'Péssimo'
    when 4..8
      'Mau'
    when 8..12
      'Suficiente'
    when 12..16
      'Bom'
    when 16..18
      'Muito Bom'
    when 18..20
      'Excelente'
    end
  end
end
