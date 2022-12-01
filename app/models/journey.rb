# frozen_string_literal: true

# Table for the games that simulate semesters
class Journey < ApplicationRecord
  has_many :chairs, dependent: :destroy
  has_many :subjects, through: :chairs
  has_many :quizzes, class_name: 'Quiz', foreign_key: 'journey_id'
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
  belongs_to :soundtrack, class_name: 'Soundtrack', foreign_key: 'soundtrack_id'

  # For a given journey, sets a job that will increase the level after a certain
  # amount of time.
  def make_checkpoint
    return unless level < 7

    JourneyCheckpointJob.set(wait: (chairs.size * [0, 10, 10, 11, 7, 16, 21][level]).minutes).perform_later(id)
  end
end
