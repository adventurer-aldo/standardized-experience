class Answer < ApplicationRecord
  belongs_to :question, foreign_key: 'question_id'
  belongs_to :quiz, foreign_key: 'quiz_id'
end