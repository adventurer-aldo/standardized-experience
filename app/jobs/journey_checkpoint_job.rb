# For a given journey, performs a checkpoint when the level will be increased
class JourneyCheckpointJob < ApplicationJob
  queue_as :default

  def perform(journey_id)
    @journey = Journey.find_by(id: journey_id)
    leveler
    @journey.end_time = Time.zone.now if @journey.level > 6
    @journey.save
    @journey.make_checkpoint
    JourneyChannel.broadcast_to(@journey, level: @journey.level, cheer: Misc::Text.cheer[@journey.level].sample)
  end

  # Increases the level according to what tests have been done and if there's no need to go further.
  def leveler
    return unless @journey.level < 7

    target_level = %i[nil first second reposition dissertation exam recurrence][@journey.level]
    @journey.chairs.where(target_level => nil).update(target_level => 0) unless @journey.level < 3
    solve_repositions
    @journey.level += 1 if @journey.level == 3 && @journey.chairs.where.not(dissertation: nil).exists?
    @journey.level += 1
    @journey.level += 1 if @journey.level == 5 && @journey.chairs.where.not(exam: nil).exists?
    @journey.level += 1 if @journey.level == 6 && @journey.chairs.where.not(recurrence: nil).exists?
  end

  # Attributes grade 0 to chairs where reposition isn't made and the quiz wasn't made.
  def solve_repositions
    return unless @journey.level == 3

    @journey.chairs.where(first: nil).update(first: 0)
    @journey.chairs.where(second: nil).update(second: 0)
  end
end
