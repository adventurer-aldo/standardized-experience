class DailyChallengesJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    rand(1..6).times do
      subject = Subject.where(visibility: 0).map(&:id).sample
      quiz = 1135
      subject.challenges.create(quiz_id: quiz, date: Date.new(Time.now.year, Time.now.mon, Time.now.day))
    end
    DailyChallengesJob.set(wait: 24.hours).perform_later
  end
end
