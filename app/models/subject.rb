class Subject < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :chairs, class_name: 'chair', foreign_key: 'subject_id', dependent: :destroy
end