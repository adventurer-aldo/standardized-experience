class JourneyChannel < ApplicationCable::Channel
  def subscribed
    @journey = Journey.find_by(id: params[:id].to_i)
    stream_for @journey
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
