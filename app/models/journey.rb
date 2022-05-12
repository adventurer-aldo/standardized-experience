class Journey < ApplicationRecord
  has_many :chairs, dependent: :destroy
end