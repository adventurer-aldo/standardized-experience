class Chair < ApplicationRecord
  belongs_to :journey, foreign_key: 'journey_id'
  belongs_to :subject, foreign_key: 'subject_id'
end
