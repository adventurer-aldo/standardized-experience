# For a given journey, issues a checkpoint when the level will be increased
class JourneyCheckpointJob < ApplicationJob
  queue_as :default

  def perform(journey_id)
    journey = Journey.find_by(id: journey_id)
    if journey.level < 7
      target_level = %i[nil first second reposition dissertation exam recurrence][journey.level]
      journey.chairs.where(target_level => nil).update(target_level => 0) unless journey.level < 3
      journey.level += 1 if journey.level == 3 && journey.chairs.where.not(dissertation: nil).exists?
      journey.level += 1
      journey.level += 1 if journey.level == 5 && journey.chairs.where.not(exam: nil).exists?
      journey.level += 1 if journey.level == 6 && journey.chairs.where.not(recurrence: nil).exists?
    end
    journey.end_time = Time.zone.now if journey.level > 6
    journey.save!
  end
end
