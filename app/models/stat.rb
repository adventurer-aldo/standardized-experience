class Stat < ApplicationRecord
  belongs_to :journey, foreign_key: "current_journey"
end