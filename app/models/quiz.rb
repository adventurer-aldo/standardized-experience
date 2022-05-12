class Quiz < ApplicationRecord
  has_many :answers, class_name: "answer", dependent: :destroy
end