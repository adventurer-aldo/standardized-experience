class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :trackable
  has_one :stat, class_name: 'Stat', foreign_key: 'user_id'
  has_many :quizzes, through: :stat
  has_many :subjects, through: :stat
  has_many :questions, through: :stat
  has_many :journeys, through: :stat
  has_many :evaluables, through: :stat
  has_many :lessons, through: :stat
end
