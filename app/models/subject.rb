class Subject < ApplicationRecord
  has_many :questions, class_name: 'Question', foreign_key: 'subject_id', dependent: :destroy
  has_many :chairs, class_name: 'Chair', foreign_key: 'subject_id', dependent: :destroy
  has_many :quizzes, class_name: 'Quiz', foreign_key: 'subject_id', dependent: :destroy
  has_many :evaluables, class_name: 'Evaluable', foreign_key: 'subject_id', dependent: :destroy
  has_many :challenges, class_name: 'Challenges', foreign_key: 'subject_id', dependent: :destroy
  has_many :lessons, class_name: 'Lessons', foreign_key: 'subject_id', dependent: :destroy
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
end
