class Chair < ApplicationRecord
  belongs_to :journey, foreign_key: 'journey_id'
end