class Question < ApplicationRecord
  has_one_attached :image
  belongs_to :subject, foreign_key: 'subject_id'
  has_many :answers, foreign_key: 'question_id', dependent: :destroy
  has_many :choices, foreign_key: 'question_id', dependent: :destroy
end