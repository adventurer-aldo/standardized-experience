class Choice < ApplicationRecord
  has_one_attached :image
  belongs_to :question, foreign_key: 'question_id'
end
