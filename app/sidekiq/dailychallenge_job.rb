class DailyChallengeJob
  include Sidekiq::Job

  def perform(*args)
    3.times do
      Challenge.create(quiz_id: 1, date: Time.zone.now)
    end
  end
  
end
