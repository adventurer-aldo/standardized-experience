# Extra statements for a question. Contains either the false answers
# or the layout for the answers.
class Choice < ApplicationRecord
  has_one_attached :image
  belongs_to :question, foreign_key: 'question_id'
end
