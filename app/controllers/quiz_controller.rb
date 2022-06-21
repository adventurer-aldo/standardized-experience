class QuizController < ApplicationController
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
      'Exercícios',
      'Teste 1',
      'Teste 2',
      'Teste de Reposição',
      'Trabalho de Dissertação',
      'Exame Normal',
      'Exame de Recorrência'
    ]

    @professorNames = [
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

    @quiz_durations = [5, 9, 9, 10, 6, 15, 20]

    case @formats
    when 0
      @ending = ["#{@professorNames.sample}/#{@professorNames.sample}", 'center']
    when 1
      @test_name[1] = '1º Teste de Frequência'
      @test_name[2] = '2º Teste de Frequência'
    when 2
      @test_name[1] = 'I Teste'
      @test_name[2] = 'II Teste'
      @ending = [@professorNames.sample, 'left']
    end
  end

  #=======================================================================================
  # -- INDEX
  # The main page. Takes parameters LEVEL and SUBJECT before choosing which questions to
  # show. Randomly selects questions based on those parameters and takes care of other
  # extra transitions.
  #=======================================================================================

  def index
    @journey = if params[:journey] && Journey.where(id: params[:journey].to_i).exists?
                 Journey.find_by(id: params[:journey].to_i)
               else
                 Journey.last
               end

    @subject = if params[:subject] && Subject.where(id: params[:subject].to_i).exists?
                 Subject.where(id: params[:subject]).first
               elsif Subject.where(evaluable: 1).exists?
                 Subject.where(evaluable: 1).order(Arel.sql('RANDOM()')).limit(1).first
               else
                 Subject.all.order(Arel.sql('RANDOM()')).limit(1).first
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

    base_query = @subject.questions.order(Arel.sql('RANDOM()'))

    all_questions = case @level
                    when 0
                      base_query.where.not(level: 3).limit(rand(3..10)) # Prática
                    when 1
                      base_query.where(level: 1).limit(rand(10..35)) # Teste 1
                    when 2
                      base_query.where(level: 2).limit(rand(10..28)) + base_query.where(level: 1).limit(rand(0..7)) # Teste 2
                    when 3
                      base_query.where.not(level: [3, 4]).limit(rand(10..40)) # Reposição
                    when 4
                      base_query.where(level: 3).limit(rand(10..40)) # Dissertação
                    when 5
                      base_query.where(level: 4).limit(rand(5..30)) + base_query.where.not(level: [3, 4]).limit(rand(10..20)) # Exame
                    when 6
                      base_query.limit(rand(50..100)) # Recorrência
                    end

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
            end
    @ost_index = @ost[0].index(@ost[0].sample)

    @full_query = all_questions.shuffle

    @quiz = Quiz.create(
      subject_id: @subject.id,
      first_name: '', last_name: '',
      journey_id: @journey.id,
      start_time: Time.zone.now,
      format: @format,
      level: @level
    )

    @full_query.each do |question|
      updated_frequency = question.frequency
      updated_frequency[0] += 1
      question.update(frequency: updated_frequency)
      type = rand(0..(question.question_types.size - 1)).to_i
      calculated_variables = []

      case question.question_types[type]
      when 'choice', 'multichoice', 'veracity'
        choices = question.choices.map(&:id).map(&:to_s)
        calculated_variables = case question.question_types[type]
                               when 'veracity'
                                 question.answer.each_with_index do |_choice_answer, index|
                                   choices.push("a#{index}")
                                 end
                                 choices.shuffle!
                                 choices[0..rand(1..(choices.size - 1)).to_i]
                               else
                                 choices = choices[0..rand(0..(choices.size - 1)).to_i]
                                 question.answer.each_with_index do |_choice_answer, index|
                                   choices.push("a#{index}")
                                 end
                                 choices.shuffle!
                                 choices
                               end
      when 'formula'
        que = question.question.dup
        randoms = que.count('#')
        randoms.times do 
          calculated_variables << "#{que[/#£(.*?)§/,1]}".split(',')
          que[que.index('#£')..que.index('§')] = ''
        end
        calculated_variables.map! do |n|
          c = n.map(&:to_f)
          case n.size
          when 1
            Float(rand(1..(c.first))).round(2).to_s
          when 2
            Float(rand(c.first..c.last)).round.to_s
          when 3
            Float(rand(c.first..c.last)).round(1).to_s
          when 4
            Float(rand(c.first..c.last)).round(2).to_s
          when 5
            Float(rand(c.first..c.last)).round(3).to_s
          else
            Float(rand(20_000)).round(2).to_s
          end
        end
      end

      Answer.create(
        quiz_id: @quiz.id,
        attempt: '',
        question_id: question.id,
        grade: (Float(20) / @full_query.size),
        question_type: type,
        variables: calculated_variables
      )
    end

    @quiz_start = @quiz.start_time.time
    @quiz_end = Time.at(@quiz_start.to_i + @quiz_durations[@level] * 60)
  end

  #=======================================================================================
  # -- SUBMIT
  # Takes forms from index and updates the database accordingly, then redirects to /result
  # to display the data.
  #=======================================================================================
  def submit
    @quiz = Quiz.find_by(id: params[:quizID].to_i)
    @quiz.update(end_time: Time.zone.now)
    @quiz.update(first_name: params[:first_name]) if params[:first_name]
    @quiz.update(last_name: params[:last_name]) if params[:last_name]
    journey = @quiz.journey

    if params[:answer]
      params[:answer].each do |id, answer|
        ans = Answer.find_by(id: id.to_i)
        case ans.question.question_types[ans.question_type]
        when 'table'
          og = ans.question.answer.map { |row| row.split('|') }
          answer.each do |row, input|
            input.each do |which_column, attempt|
              og[row.to_i][which_column.to_i] = "?#{attempt}?"
            end
          end
          og.map! { |row| row.join('|') }
          ans.update(attempt: og)
        else
          ans.update(attempt: (answer.instance_of?(Array) ? answer : [answer]))
        end
      end
    end

    @quiz.answers.each do |answer|
      new_frequency = answer.question.frequency.dup
      new_frequency[0] += 1
      new_frequency[1] += (helpers.correct(answer) ? 1 : 0)
      new_frequency[2] += (helpers.correct(answer) ? 0 : 1)
      answer.question.update(frequency: new_frequency)
    end

    if journey.level == @quiz.level && journey.level < 7 && journey.chairs.where(subject_id: @quiz.subject.id).exists?
      chair = journey.chairs.where(subject_id: @quiz.subject.id).first
      case journey.level
      when 1
        chair.update(first: helpers.grade(@quiz)) if chair.first.nil?
      when 2
        chair.update(second: helpers.grade(@quiz)) if chair.second.nil?
        unless chair.first.nil? || chair.second.nil?
          chair.update(reposition: 0.0)
          unless chair.dissertation.nil?
            if helpers.media(chair) >= 14.5
              chair.update(exam: 20.0)
              chair.update(recurrence: 20.0)
            elsif helpers.media(chair) < 9.5
              chair.update(exam: 0.0)
              chair.update(recurrence: 0.0)
            end
          end
        end
      when 3
        chair.update(reposition: helpers.grade(@quiz)) if chair.reposition.nil?
        if chair.first.nil? || !chair.second.nil?
          chair.update(first: helpers.grade(@quiz))
        elsif !chair.first.nil? || chair.second.nil?
          chair.update(second: helpers.grade(@quiz))
        elsif chair.first.nil? || chair.second.nil?
          chair.update(first: (helpers.grade(@quiz) / 2.0).round(2))
          chair.update(second: (helpers.grade(@quiz) / 2.0).round(2))
        end
        chair.update(reposition: helpers.grade(@quiz))
      when 4
        chair.update(dissertation: helpers.grade(@quiz)) if chair.dissertation.nil?
        if helpers.media(chair) >= 14.5
          chair.update(exam: 20.0)
          chair.update(recurrence: 20.0)
        elsif helpers.media(chair) < 9.5
          chair.update(exam: 0.0)
          chair.update(recurrence: 0.0)
        end
      when 5
        if chair.exam.nil?
          chair.update(exam: helpers.grade(@quiz))
          chair.update(recurrence: 20.0) if helpers.grade(@quiz) >= 9.5
        end
      when 6
        chair.update(recurrence: helpers.grade(@quiz)) if chair.recurrence.nil?
      end
    end

    if journey.level < 7
      journey.update(level: 2) unless journey.chairs.where(first: nil).exists?
      journey.update(level: 3) unless journey.chairs.where(second: nil).exists?
      journey.update(level: 4) unless journey.chairs.where(reposition: nil).exists?
      journey.update(level: 5) unless journey.chairs.where(dissertation: nil).exists? || (journey.chairs.where(first: nil).exists? || journey.chairs.where(second: nil).exists?)
      journey.update(level: 6) unless journey.chairs.where(exam: nil).exists?
      journey.update(level: 7) unless journey.chairs.where(recurrence: nil).exists?
    end

    redirect_to results_path(id: params[:quizID])
  end

  #=======================================================================================
  # -- RESULT
  # Takes a mandatory Quiz ID as an attribute and retrieves the array, level and subject
  # of that quiz. Gets each answer object from the array of IDs from the quiz's answer
  # column, and attempts to match it to its Question ID to see if it's correct in order to
  # determine the grade.
  #=======================================================================================
  def results
    @quiz = Quiz.find_by(id: params[:id].to_i)
    @grade = helpers.grade(@quiz)
    @quiz_start = Time.parse(@quiz.start_time)
    @quiz_end = Time.parse(@quiz.end_time)
    @duration = Time.at(@quiz_end.to_i - @quiz_start.to_i)

    @fanfare =  if @grade < 7
                  helpers.audio_path('failhard.ogg')
                elsif @grade < 9.5
                  helpers.audio_path('fail.ogg')
                elsif @grade < 14.5
                  helpers.audio_path('succeed.ogg')
                elsif @grade < 18
                  helpers.audio_path('succeedhard.ogg')
                elsif @grade < 20
                  helpers.audio_path('succeedharder.ogg')
                else
                  helpers.audio_path('succeedhardest.ogg')
                end
  end
 
end
