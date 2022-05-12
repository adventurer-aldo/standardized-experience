class Question < ApplicationRecord
    has_one_attached :image
    belongs_to :subject, foreign_key: 'subject_id'
end