class Subject < ApplicationRecord
  has_many :questions, class_name: 'Question', foreign_key: 'subject_id', dependent: :destroy
  has_many :chairs, class_name: 'Chair', foreign_key: 'subject_id', dependent: :destroy
  has_many :quizzes, class_name: "Quiz", foreign_key: "subject_id", dependent: :destroy
end