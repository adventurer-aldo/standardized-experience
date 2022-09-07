class Quiz < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :subject, foreign_key: 'subject_id'
  belongs_to :journey, foreign_key: 'journey_id'
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
end