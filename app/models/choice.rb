class Choice < ApplicationRecord
    has_one_attached :image
    belongs_to :question, class_name: "question", foreign_key: "question"
end