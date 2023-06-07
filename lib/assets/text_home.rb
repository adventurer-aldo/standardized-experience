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
        'You have been hardened by your first ordeal. Push through!',
        'Courage is unnecessary. Just do it.',
        'In the end, without real consequences fear is nothing other overthinking.',
        'Practice. And make this your last test.',
        'The second hurdle is tougher than the first, but so will you be after overcoming it.',
        "No more delays. Let's go!"],
       ['For the wise, this is nothing but time to prepare for the upcoming battles.',
        'What did you think of the tests so far?',
        'Better revise your weaknesses before proceeding.',
        'A second chance for those who wasted their first.',
        "Don't relax too much just because you can afford it.",
        'Life can be forgiving at this, but do not abuse its forgiveness.',
        'Forget the failures and start thinking about how to turn them into successes.',
        "Haven't given up yet? We'll see how long you last..."],
       ['Show what you know.',
        "Prove your knowledge isn't a fluke.",
        "It won't be just any test. Don't lower your guard."],
       ["It's here. The \"final\" battle.",
        'You can do this.',
        'No thoughts. Head empty.',
        'Time to claim your earned victory.',
        'Show what your experiences have taught you.',
        "You prepared yourself for this, haven't you?",
        "No more delays. For the last time...let's go!",
        "It's just another obstacle with a pretty name.",
        'If you got this far, you can finish this properly.',
        "I don't get why you didn't try to exempt yourself from this.",
        "Too many people wouldn't be able to get this far. Yet, you're here...",
        "You didn't go through all of that just to crumble here, did you?"],
       ["I wish I wasn't here...",
        "Well, well... Look who's here.",
        'No one said this would be easy.',
        'This is your chance at redemption.',
        'Being overconfident resulted in this.',
        'You got too relaxed, and this is what happened.',
        'I knew you would be here sooner or later. You screwed up.',
        "Second chances don't imply a lighter judgement, but a harsher one.",
        'Was you getting this far just a fluke?',
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
        'Well? What will you do next?'
       ],
       ['For someone as extraordinary as you, there must be even more extraordinary challenges to match.',
        'Well, genius. I hope the upcoming challenge can be at least a bit hard to you.',
        "This time, we're the ones being tested by your skills.",
        'Can we even match your level?',
        'An extraordinary exam...for an extraordinary student.',
        "It's been a while since anyone reached these levels...",
        'Now, how do we challenge you...',
        'I am in awe of your presence and your skills.',
        "There's nothing more we can teach you. We can only test your exceptionality.",
        'Your name will be saved in our history as one of the extraordinary ones.',
        'If you know better than us, do you even need us?',
        'Such talent. Such knowledge. Such extraordinary mind.'
       ]]
    end

    def self.evaluate(grade)
      case grade.round
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
          'Really?',
          'TRY AGAIN!',
          'This is embarassing.',
          'Train. Train. Train. Train!',
          'Did a question surprise you?',
          "Let's go with a fighting spirit!",
          'And you think you can pass like this?',
          "You're not on zero. You're on your first steps.",
          "You're going to need to put more effort into this.",
          "Not the worst you've done, so this is a win in my books.",
          ''
        ].sample
      when 7..9
        [
          'Did you study?',
          "I'm not going easy on you!",
          "Not too bad, but not good either.",
          'Better revise the content before trying again.',
          "You're improving, but still far from being good.",
          'And you thought you could get exempted like this...',
          'You will never get exempted if you keep up like this.',
          ''
        ].sample
      when 10..12
        [
          'I liked it!',
          'Halfway there!',
          'Actually, that one was easy.',
          'Celebrate, but for five minutes.',
          "I was taking it easy. Don't start relaxing.",
          "Don't sleep yet. There's still more up ahead.",
          'Good grade. You can move on with life at least.',
          "Good! Now try getting #{rand(1..8)} more on your score next time.",
          "If you've been failing a lot lately, you should be happy with this.",
          ''
        ].sample
      when 13..14
        [
          "What's this? You're evolving!",
          "You're showing me some results!",
          "Train! You're still not on the top yet.",
          "I'm getting proud, but don't lower your guard yet!",
          'Way above average. Maybe you can also get exempted.',
          ''
        ].sample
      when 15..17
        [
          'WAY TO GO!',
          'Your knowledge is showing.',
          'Hey, you could get exempted with a grade like this!',
          "Amazing! Why not try a better grade? You're certainly capable!",
          ''
        ].sample
      when 18..19
        [
          "You're finally taking this seriously.",
          "Hol' up... When did you study all this?",
          'Very good. Can you get the perfect score?',
          "Better ready your sleeves, because next time's gonna be harder.",
          ''
        ].sample
      when 20
        [
          'Good job.',
          "I'm dreaming, aren't I?",
          'This is why I trust you.',
          'You know too much now...',
          'Such knowledge... I like it!',
          "I wasn't expecting this one...",
          'Perfect. Just...perfect! You nailed it.',
          'Better wake up, because this feels like a dream.',
          'Hard to believe you were struggling with this before.',
          ''
        ].sample
      end
    end
  end


end
