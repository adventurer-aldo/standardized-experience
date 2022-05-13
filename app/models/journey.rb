class Journey < ApplicationRecord
  has_many :chairs, dependent: :destroy
  belongs_to :soundtrack, class_name: 'Soundtrack', foreign_key: 'soundtrack_id'
end