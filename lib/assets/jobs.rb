def daily_challenge
  rand(1..6).times do
    subject = Subject.all.map(&:id).sample
    quiz = 0
    # goal = case rand(1..6)
    Challenge.create(subject_id: subject, quiz_id: quiz, date: Time.zone.now)
  end

  time = Time.at(Time.now.to_i + 86_400)
  QC.enqueue_at(time, 'daily_challenge')
end

def journey_update(journey_id, set_level)
  journey = Journey.find_by(id: journey_id)
  if [5, 6].include?(set_level) && !journey.chairs.where(exam: nil, recurrence: nil).exists?
    journey.update(level: 7)
  else
    journey.update(level: set_level)
  end
end