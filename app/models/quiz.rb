class Quiz < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :subject, foreign_key: "subject_id"
end