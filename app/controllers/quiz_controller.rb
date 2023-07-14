class QuizController < ApplicationController
  before_action :authenticate_user!
  before_action :setup

  #=======================================================================================
  # -- SETUP
  # Common for all methods of the controller. Defines common variables such as the formats
  # names and the endings of the tests, as wll as the time the quizzes will take.
  #=======================================================================================
  def setup
    @formats = 0..2
    @ending = ['']

    @test_name = [
      'Exercises',
      'Test 1',
      'Test 2',
      'Reposition Test',
      'Job',
      'Normal Exam',
      'Recurrence Exam',
      'Extraordinary Exam'
    ]

    @professor_names = [
      'John Watson',
      'Mary Watson',
      'James Watson',
      'Nathan Swift',
      'Ema Skye',
      'James Bond',
      'Michael Scott',
      'Dwight Schrute',
      'Jim Halpert',
      'Pam Beesly',
      'Ryan Howard',
      'Kelly Kapoor',
      'Stanley Hudson',
      'Angela Martin',
      'Kevin Malone',
      'Toby Flenderson',
      'Darryl Philbin',
      'Oscar Martinez'
    ]

    @quiz_durations = [5, 9, 9, 10, 6, 15, 20, 60]

    case @formats
    when 0
      @ending = ["#{@professor_names.sample}/#{@professor_names.sample}", 'center']
    when 1
      @test_name[1] = '1st Frequency Test'
      @test_name[2] = '2nd Frequency Test'
    when 2
      @test_name[1] = 'Test I'
      @test_name[2] = 'Test II'
      @ending = [@professor_names.sample, 'left']
    end
  end

  #=======================================================================================
  # -- INDEX
  # The main page. Takes parameters LEVEL and SUBJECT before choosing which questions to
  # show. Randomly selects questions based on those parameters and takes care of other
  # extra transitions.
  #=======================================================================================

  def index
    @journey = if params[:journey] && current_user.journeys.where(id: params[:journey].to_i).exists?
                 Journey.find_by(id: params[:journey].to_i)
               else
                 current_user.journeys.last
               end

    @subject = if params[:subject] && current_user.subjects.or(Subject.where(visibility: 0)).where(id: params[:subject].to_i).exists?
                 Subject.find_by(id: params[:subject])
               elsif !current_user.evaluables.empty?
                 current_user.evaluables.sample.subject
               else
                 Subject.where(visibility: 0).order(Arel.sql('RANDOM()')).first
               end

    @level = if !params[:level] || (@journey.level < params[:level].to_i)
               0
             else
               params[:level].to_i
             end

    @format = if @level.zero?
                rand(@formats).round(0)
              elsif @journey.chairs.where(subject_id: @subject.id).exists?
                @journey.chairs.find_by(subject_id: @subject.id).format
              else
                0
              end

    base_query = @subject.questions.joins(:frequencies).order('frequencies.miss_streak' => 'DESC', 'frequencies.appearances' => 'ASC').order(Arel.sql('RANDOM()'))
    focus = current_user.stat.evaluables.where(subject_id: @subject.id)&.first&.focus || 0

    chosen = current_user.stat.evaluables.find_by(subject_id: @subject.id)
    base_query = base_query.where('tags && ARRAY[?]::text[]', chosen.tags) unless [[], nil].include? chosen&.tags

    all_questions = case @level
                    when 0
                      base_query.where(level: [[0, 1, 2, 4], 1, 2][focus]).limit(rand(3..10))
                    when 1
                      base_query.where(level: focus.zero? ? 1 : focus).limit(rand(10..35))
                    when 2
                      case focus
                      when 0
                        base_query.where(level: 2).limit(rand(10..28)) + base_query.where(level: 1).limit(rand(0..7)) # Teste 2
                      when 1, 2, 4
                        base_query.where(level: focus).limit(rand(10..40))
                      end
                    when 3
                      base_query.where(level: [1, 2]).limit(rand(10..40)) # Reposição
                    when 4
                      base_query.where(level: 3).limit(rand(10..40)) # Dissertação
                    when 5
                      case focus
                      when 0
                        base_query.where(level: 4).limit(rand(5..30)) + base_query.where.not(level: [3, 4]).limit(rand(10..25)) # Exame
                      when 1, 2, 4
                        base_query.where(level: focus).limit(rand(25..45)) # Exame 1
                      end
                    when 6
                      base_query.where(level: focus.zero? ? [1, 2, 4] : focus).limit(rand(50..100))
                    when 7
                      base_query.where(level: focus.zero? ? [1, 2, 4] : focus)
                    end.shuffle

    @ost =  case @level
            when 0
              [@journey.soundtrack.practice, @journey.soundtrack.practice_rush]
            when 1
              [@journey.soundtrack.first, @journey.soundtrack.first_rush]
            when 2
              [@journey.soundtrack.second, @journey.soundtrack.second_rush]
            when 3
              [@journey.soundtrack.second, @journey.soundtrack.second_rush]
            when 4
              [@journey.soundtrack.dissertation, @journey.soundtrack.dissertation_rush]
            when 5
              [@journey.soundtrack.exam, @journey.soundtrack.exam_rush]
            when 6
              [@journey.soundtrack.recurrence, @journey.soundtrack.recurrence_rush]
            when 7
              [@journey.soundtrack.extraordinary, @journey.soundtrack.extraordinary_rush] # ,
               # @journey.soundtrack.extraordinary_rusher, @journey.soundtrack.extraordinary_rushest]
            end
    @ost_index = @ost[0].index(@ost[0].sample)
    @ost_name = @journey.soundtrack.name

    @quiz = current_user.stat.quizzes.create(
      subject_id: @subject.id, journey_id: @journey.id,
      start_time: Time.zone.now, format: @format, level: @level
    )

    all_questions.each do |question|
      type = question.question_types.sample

      @quiz.answers.create(
        question_id: question.id,
        grade: (Float(20) / all_questions.size),
        question_type: type,
        variables: question.generate_variables(type)
      )
    end

    if @subject.practical == 1
      @practical = @quiz.answers.order(id: :asc).map do |answer|
        { id: answer.id, question_type: answer.question_type, choices: helpers.map_with_decoys(answer.variables),
          question: answer.question.question.gsub('\n', '\n '), answers_size: answer.question.answer.size,
          image: answer.question.image.attached? ? url_for(answer.question.image) : nil }
      end
      @time_limit = (@quiz.start_time.to_f + @quiz_durations[@quiz.level]) * 1000
    end

    @quiz.start_time = @quiz.start_time.time
    @end_time = Time.at(@quiz.start_time.to_time.to_i + @quiz_durations[@level] * 60)
  end

  #=======================================================================================
  # -- SUBMIT
  # Takes forms from index and updates the database accordingly, then redirects to /result
  # to display the data.
  #=======================================================================================
  def submit
    @quiz = Quiz.find_by(id: params[:quizID].to_i)
    @quiz.end_time = Time.zone.now
    @quiz.first_name = params[:first_name] if params[:first_name]
    @quiz.last_name = params[:last_name] if params[:last_name]
    @quiz.save

    params[:answer]&.each do |id, answer|
      ans = Answer.find_by(id: id.to_i)
      ans&.update(attempt: answer.map(&:rstrip))
      freq = Frequency.find_or_create_by(question_id: ans.question_id, stat_id: current_user.stat.id)
      freq.appearances += 1
      if ans.correct?
        freq.hit_streak += 1
        freq.miss_streak = 0 if freq.hit_streak >= 3
      else
        freq.miss_streak += 1
        freq.hit_streak = 0
      end
      freq.save
    end

    journey_update(@quiz.journey)

    redirect_to results_path(id: params[:quizID])
  end

  #=======================================================================================
  # Posts the quiz's score to the Journey.
  #=======================================================================================
  def journey_update(journey)
    return unless journey.level == @quiz.level && journey.level < 7 && journey.chairs.where(subject_id: @quiz.subject.id).exists?

    chair = journey.chairs.where(subject_id: @quiz.subject.id).first
    case journey.level
    when 1
      chair.first = @quiz.grade if chair.first.nil?
    when 2
      chair.second = @quiz.grade if chair.second.nil?
      unless chair.first.nil? || chair.second.nil?
        chair.reposition = 0.0
        unless chair.dissertation.nil?
          if helpers.media(chair) >= 14.5
            chair.exam = 20.0
            chair.recurrence = 20.0
          elsif helpers.media(chair) < 9.5
            chair.exam = 0.0
            chair.recurrence = 0.0
          end
        end
      end
    when 3
      chair.reposition = @quiz.grade if chair.reposition.nil?
      if chair.first.nil? && !chair.second.nil?
        chair.first = @quiz.grade
      elsif !chair.first.nil? && chair.second.nil?
        chair.second = @quiz.grade
      elsif chair.first.nil? && chair.second.nil?
        chair.first = (@quiz.grade / 2.0).round(2)
        chair.second = (@quiz.grade / 2.0).round(2)
      end
      chair.reposition = @quiz.grade
    when 4
      chair.dissertation = @quiz.grade if chair.dissertation.nil?
      if helpers.media(chair) >= 14.5
        chair.exam = 20.0
        chair.recurrence = 20.0
      elsif helpers.media(chair) < 9.5
        chair.exam = 0.0
        chair.recurrence = 0.0
      end
    when 5
      if chair.exam.nil?
        chair.exam = @quiz.grade
        chair.recurrence = 20.0 if @quiz.grade >= 9.5
      end
    when 6
      chair.recurrence = @quiz.grade if chair.recurrence.nil?
    end

    chair.save
    if journey.duration == 0 && !journey.chairs.where(%i[nil first second reposition dissertation exam recurrence][journey.level] => nil).exists?
      JourneyCheckpointJob.perform_now(journey.id)
    end
  end

  #===========================================
  # -- RESULT
  # Takes a mandatory Quiz ID as an attribute and retrieves the array, level and subject
  # of that quiz. Gets each answer object from the array of IDs from the quiz's answer
  # column, and attempts to match it to its Question ID to see if it's correct in order to
  # determine the grade.
  #============================================
  def results
    @quiz = Quiz.find_by(id: params[:id].to_i)
    @end_time = @quiz.end_time
    @grade = @quiz.grade(text: true)
    grade_num = @grade.gsub(',', '.').to_f
    @quiz.update(last_grade: grade_num)
    @duration = Time.at(@quiz.end_time.to_time.to_i - @quiz.start_time.to_time.to_i)
    @fanfare = if grade_num < 7
                 'results/failhard.ogg'
               elsif grade_num < 9.5
                 'results/fail.ogg'
               elsif grade_num < 14.5
                 'results/succeed.ogg'
               elsif grade_num < 18
                 'results/succeedhard.ogg'
               elsif grade_num < 20
                 'results/succeedharder.ogg'
               else
                 'results/succeedhardest.ogg'
               end
  end

end
