# Table for the site's information on each user. It is separated from the actual user
# table as to not lose any information if they delete their accounts.
class Stat < ApplicationRecord
  belongs_to :theme, foreign_key: 'theme_id'
  belongs_to :user, foreign_key: 'user_id'
  has_many :journeys, foreign_key: 'stat_id'
  has_many :questions, foreign_key: 'stat_id'
  has_many :quizzes, foreign_key: 'stat_id'
  has_many :subjects, foreign_key: 'stat_id'
  has_many :evaluables, foreign_key: 'stat_id'
  has_many :lessons, foreign_key: 'stat_id'
  has_many :frequencies, class_name: 'Frequency', foreign_key: 'stat_id', dependent: :destroy
end
