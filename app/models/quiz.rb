# Table that groups all the questions for a quiz in one.
class Quiz < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :subject, foreign_key: 'subject_id'
  belongs_to :journey, foreign_key: 'journey_id'
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
  has_many :questions, through: :answers

  def grade(text: false)
    total = 0.0
    answers.each do |answer|
      total += if answer.correct?
                 answer.grade
               else
                 answer.negative_grade.zero? ? 0 : 0 - answer.grade
               end
    end
    text == true ? total.round(2).to_s.gsub('.', ',') : total.round(2)
  end
end
