class Stat < ApplicationRecord
  belongs_to :journey, foreign_key: "current_journey"
  belongs_to :theme, foreign_key: "theme_id"
end