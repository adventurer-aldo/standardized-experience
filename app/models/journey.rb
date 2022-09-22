# Table for the games that simulate semesters
class Journey < ApplicationRecord
  has_many :chairs, dependent: :destroy
  has_many :subjects, through: :chairs
  has_many :quizzes, class_name: 'Quiz', foreign_key: 'journey_id'
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
  belongs_to :soundtrack, class_name: 'Soundtrack', foreign_key: 'soundtrack_id'
end
