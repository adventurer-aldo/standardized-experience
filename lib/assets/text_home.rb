module Misc

  class Text
    def self.classroom(learning)
      case learning
      when 0..4
        [
          'No comments.',
          'My god. What was that?',
          'Who taught you like this!?',
          "You'll be repeating this subject.",
          'You have a long way ahead.',
          'At least you know that 1+1=2, right?',
          'Take extra lessons, student.',
          "That wasn't very smart of you.",
          ''
        ].sample
      when 4..8
        [
          'My god.',
          "You'll need to practice more, alone.",
          'I see this is a difficult tag for you.',
          "Maybe I'm not cut out to teach you.",
          ''
        ].sample
      when 8..12
        [
          'I can see progress. I believe in you!',
          "With a few more revisions, you'll be ready for a journey",
        ].sample
      when 12..16
        [
          'Reward yourself and rest. You need it.',
          "Nice going. You're ready for the tests!",
          "Calm down. Rushing won't get you far."
        ].sample
      when 16..18
        [
          "I've seen your mistakes. They're not unusual.",
          'A minuscule mistake, but everything else is good!',
          "You don't need a lesson to improve. Do a small revision and you'll be fine!"
        ].sample
      when 18..20
        [
          'You are reaching the levels of a teacher.',
          "Soon you'll have the skills to teach someone.",
          "The journey was long, but we're here at last.",
          " Who said that hard work doesn't reward?"
        ].sample
      end
    end

    def self.cheer
      [['This is only the beginning. Try seeing your potential.',
        'Test your abilities.',
        'The most basic of the basic. How will you fare against this challenge?',
        "No more delays. Let's go."],
       ['The battle is about to begin.',
        'Get ready.',
        'The battle has begun.',
        'Are you ready?',
        'Nervous? Great.',
        'The beginning decides the end.',
        'I hope you are ready.',
        "Don't chicken out at the beginning.",
        "Training time's over. Let's begin!",
        'First steps matter the most.',
        "It will be easy for who's ready.",
        "It's the first obstacle, and there's no other way besides forward!",
        "Can you really win? It's no joke."],
       ["The first battle is over, but there's still more up ahead.",
        "It's the second obstacle. Prepare yourself.",
        "A completely different battle lies ahead, but what you've learnt before will still be useful.",
        "No more delays. Let's go!"],
       ['For the wise, this is nothing but time to prepare for the upcoming battles.',
        'Better revise your weaknesses before proceeding.',
        'A second chance for those who wasted their first.',
        'Forget the failures and start thinking about how to turn them into successes.',
        "Haven't given up yet? We'll see how long you last..."],
       ['Show what you know.',
        "Prove your knowledge isn't a fluke.",
        "It won't be just any test. Don't lower your guard."],
       ["It's here. The \"final\" battle.",
        'No thoughts. Head empty.',
        "No more delays. For the last time...let's go!",
        "I don't get why you didn't try to exempt yourself from this.",
        'Time to claim your earned victory.',
        "It's just another obstacle with a pretty name.",
        "You didn't go through all of that just to crumble here, did you?"],
       ["I wish I wasn't here...",
        'Being overconfident resulted in this.',
        'No one said this would be easy.',
        "Well, well... Look who's here.",
        'I knew you would be here sooner or later. You screwed up.',
        "Second chances don't imply a lighter judgement, but a harsher one.",
        'You got too relaxed, and this is what happened.',
        'Well then.'
       ],
       ['The battle is over...',
        'One more time?',
        'You need to rest.',
        'Get a glass of water.',
        "It's finally over...",
        "You have earned #{rand(0..1000)} XP.",
        'Next time, dominate it.',
        'Every beginning has an end.',
        "You're just getting started.",
        'To the next level!',
        'What do you think of your hard work?',
        'A break is necessary. And welcome.',
        'Well? What will you do next?']]
    end
    def self.evaluate(grade)
      return  case grade.round
              when 0..4
                [
                  'No comments..',
                  'Try again. Come on.',
                  "Let's fix this.",
                  'Outlook, not so good.',
                  'Better not say anything.',
                  'Maybe you should give up.',
                  '...You got a long way ahead.',
                  'Maybe you should study something else?',
                  'Are you kidding? The results are not...',
                  "Practice more so we don't see this misery again.",
                  'Thankfully you were only testing stuff. You were just testing stuff, right?',
                  ''
                ].sample
              when 3..6
                [
                  "You're going to need to put more effort into this.",
                  "Not the worst you've done, so this is a win in my books.",
                  'Really?',
                  'This is embarassing.',
                  'Train. Train. Train. Train!',
                  'TRY AGAIN!',
                  'And you think you can pass like this?',
                  'Did a question surprise you?',
                  "You're not on zero. You're on your first steps.",
                  "Let's go with a fighting spirit!",
                  ''
                ].sample
              when 7..9
                [
                  "You're improving, but still far from being good.",
                  "In a class of perfect grade students, you're the reason their average is half of the maximum.",
                  'Better revise the content before trying again.',
                  'Did you study?',
                  "I'm not going easy on you!",
                  'You will never get exempted if you keep up like this.',
                  'And you thought you could get exempted like this...',
                  ''
                ].sample
              when 10..12
                [
                  "Good! Now try getting #{rand(1..8)} more on your score next time.",
                  'I liked it!',
                  'Actually, that one was easy.',
                  "I was taking it easy. Don't start relaxing.",
                  'Halfway there!',
                  'Good grade. You can move on with life at least.',
                  "If you've been failing a lot lately, you should be happy with this.",
                  "Don't sleep yet. There's still more up ahead.",
                  'Celebrate, but for five minutes.',
                  ''
                ].sample
              when 13..14
                [
                  'Way above average. Maybe you can also get exempted.',
                  "You're showing me some results!",
                  "I'm getting proud, but don't lower your guard yet!",
                  "Train! You're still not on the top yet.",
                  "What's this? You're evolving!",
                  ''
                ].sample
              when 15..17
                [
                  "Amazing! Why not try a better grade? You're certainly capable!",
                  'WAY TO GO!',
                  'Hey, you could get exempted with a grade like this!',
                  'Your knowledge is showing.',
                  ''
                ].sample
              when 18..19
                [
                  'Very good. Can you get the perfect score?',
                  "Hol' up... When did you study all this?",
                  "Better ready your sleeves, because next time's gonna be harder.",
                  "You're finally taking this seriously.",
                  ''
                ].sample
              when 20
                [
                  'Perfect. Just...perfect! You nailed it.',
                  'Such knowledge... I like it!',
                  "I'm dreaming, aren't I?",
                  'Good job.',
                  'Better wake up, because this feels like a dream.',
                  "I wasn't expecting this one...",
                  'Hard to believe you were struggling with this before.',
                  'This is why I trust you.',
                  ''
                ].sample
              end
    end
  end


end
