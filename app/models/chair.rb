class Chair < ApplicationRecord
    belongs_to :journey, class_name: "journey", foreign_key: "journey_id"
end