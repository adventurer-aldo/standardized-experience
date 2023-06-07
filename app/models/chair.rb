# Table for the copy of a subject for a journey, to keep up with the
# scores for the journey's progress
class Chair < ApplicationRecord
  belongs_to :journey, foreign_key: 'journey_id'
  belongs_to :subject, foreign_key: 'subject_id'
end
