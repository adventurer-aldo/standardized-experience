class Quiz < ApplicationRecord
  has_many :answers, dependent: :destroy
end