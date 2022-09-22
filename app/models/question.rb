# Table for the questions for a subject that contains the answers (what must be written at the quiz)
# and all the information pertaining itself.
class Question < ApplicationRecord
  has_one_attached :image
  belongs_to :subject, foreign_key: 'subject_id'
  has_many :answers, foreign_key: 'question_id', dependent: :destroy
  has_many :choices, foreign_key: 'question_id', dependent: :destroy
  has_many :frequencies, class_name: 'Frequency', foreign_key: 'question_id', dependent: :destroy
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
end
