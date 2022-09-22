# Table for the tracks seen throughout the experience
class Soundtrack < ApplicationRecord
  has_many :journeys, class_name: 'journey', foreign_key: 'soundtrack_id'
end