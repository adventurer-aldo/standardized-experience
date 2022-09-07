class Stat < ApplicationRecord
  belongs_to :theme, foreign_key: 'theme_id'
  belongs_to :user, foreign_key: 'user_id'
  has_many :journeys, foreign_key: 'stat_id'
  has_many :questions, foreign_key: 'stat_id'
  has_many :quizzes, foreign_key: 'stat_id'
  has_many :subjects, foreign_key: 'stat_id'
end
