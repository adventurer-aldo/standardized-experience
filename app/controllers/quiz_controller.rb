class QuizController < ApplicationController
  before_action :setup

  #=======================================================================================
  # -- SETUP
  # Common for all methods of the controller. Defines common variables such as the formats
  # names and the endings of the tests, as wll as the time the quizzes will take.
  #=======================================================================================
  def setup
    @formats = 1..1
    @ending = ['']

    @test_name = [
      'Exercícios',
      'Teste 1',
      'Teste 2',
      'Teste de Reposição',
      'Exame Normal',
      'Exame de Recorrência'
    ]

    @quiz_durations = [5, 9, 9, 10, 15, 20]

    case @formats
    when 0
      @ending = ['RR/BM', 'center']
    when 1
      @test_name[1] = '1º Teste de Frequência'
      @test_name[2] = '2º Teste de Frequência'
    end
  end

  #=======================================================================================
  # -- SHIFT
  # Creates an array of Question objects from the database that matches each ID of the
  # Answers array.
  #=======================================================================================

  def shift
    puts 'Shifting'
    @question_objects = []
    @answer_objects = []
    @answers_array.each do |answer_id|
      @answer_object = Answer.find_by(id: answer_id)
      @answer_objects << @answer_object
      @question_objects << Question.find_by(id: @answer_object.questionid)
    end
  end

  #=======================================================================================
  # -- INDEX
  # The main page. Takes parameters LEVEL and SUBJECT before choosing which questions to
  # show. Randomly selects questions based on those parameters and takes care of other
  # extra transitions.
  #=======================================================================================

  def index
    @journey = Stat.last.journey

    @subject = if params[:subject].nil? || Subject.where(title: params[:subject]).exists? == false
                 params[:subject] = Subject.all.order(Arel.sql('RANDOM()')).limit(1).first
               else
                 Subject.where(title: params[:subject]).first
               end

    @level = if !params[:level] || (@journey.level < params[:level].to_i)
               0
             else
               params[:level].to_i
             end

    @format = if params[:level].zero?
                rand(@formats).round(0)
              elsif @journey.chairs.where(subject_id: params[:subject].id).exists?
                @journey.chairs.find_by(subject_id: params[:subject].id)
              else
                0 unless @formats.include? @format
              end

    base_query = Question.where(subject_id: params[:subject]).order(Arel.sql('RANDOM()')).group(:id)

    all_questions = case params[:level]
                    when 0
                      base_query.limit(rand(3..10))
                    when 1
                      base_query.where(level: 1).limit(rand(10..35))
                    when 2
                      base_query.where(level: 2).limit(rand(10..28)) + base_query.where(level: 1).limit(rand(0..7))
                    when 3
                      base_query.where.not(level: 3).limit(rand(10..40))
                    when 4
                      base_query.where(level: 3).limit(rand(5..30)) + base_query.where.not(level: 3).limit(rand(10..20))
                    when 5
                      base_query.limit(rand(50..100))
                    end

    @full_query = all_questions.shuffle

    @questions_array = []
    @answers_array = []
    @full_query.each do |query|
      @questions_array << query.id
    end

    @questions_array.each do |n|
      @temp_question = Question.find_by(id: n)
      @temp_question.update(frequency: (@temp_question.frequency += 1))
      parameters = {}
      parameters[:type] = eval(@temp_question.questiontype).sample

      if %I[formula].include? parameters[:type]
          que = @temp_question.question.dup
          randoms = que.count('#')
          temp = []
          puts "#{randoms} times!"
          randoms.times do 
            temp << "#{que[/#£(.*?)§/,1]}".split(',')
            puts "Adding [#{que[/#£(.*?)§/,1]}]"
            que[que.index('#£')..que.index('§')] = ''
          end
          puts temp.to_s
          temp.map! do |n|
            c = n.map(&:to_f)
            puts c.to_s
            puts n.to_s
            case n.size
            when 1
              Float(rand(1..(c.first))).round(2)
            when 2
              Float(rand(c.first..c.last)).round
            when 3
              Float(rand(c.first..c.last)).round(1)
            when 4
              Float(rand(c.first..c.last)).round(2)
            when 5
              Float(rand(c.first..c.last)).round(3)
            else
              Float(rand(200_00)).round(2)
            end
          end

          parameters[:data] = temp
        end

      @answer = Answer.create(
        attempt: '',
        questionid: n,
        grade: (Float(20) / @questions_array.size),
        parameters: parameters
      )
      @answers_array << @answer.id
    end

    Quiz.create(
      subject: params[:subject],
      name: '', surname: '',
      journey: @journey,
      answerarray: @answers_array.to_s,
      timestarted: Time.now.to_i,
      timeended: Time.now.to_i,
      format: @format,
      level: params[:level]
    )
    
    @current_quiz = Quiz.last

    @stats = Stat.first
    @stats.increment!(:lastquizid)
    @stats.increment!(:totalquizzes)

    @quiz_start = Time.at(@current_quiz.timestarted)
    @quiz_end = Time.at(@quiz_start.to_i + @quiz_durations[params[:level]]*60)

    shift
  end

  #=======================================================================================
  # -- SUBMIT
  # Takes forms from index and updates the database accordingly, then redirects to /result
  # to display the data.
  #=======================================================================================
  def submit
    @current_quiz = Quiz.find_by(id: params[:quizID])
    @current_quiz.update(timeended: Time.now.to_i)

    @answers = eval(@current_quiz.answerarray)
    @answers.each do |answer_id|
      @ans = Answer.find_by(id: answer_id)
      @parameters = eval(@ans.parameters)
      @answer = "#{params[:answer]["#{@answers.index(answer_id)}"]}"
      if %I(choice multichoice veracity).include? @parameters[:type]
        @que = Question.find_by(id: @ans.questionid)
        @sourceAnswers = @que.answer.split('|')
        @sourceChoices = (Choice.select(:decoy).where(question: @que.id).order(:id)).map{|n| n.decoy }
        @choices = eval(params[:choices][@answers.index(answer_id).to_s])
        puts "Choices are #{@choices}"
        @order = []

        @choices.each do |choose|
          @order << @sourceChoices.index(choose) if @sourceChoices.include?(choose)
          @order << "#{@sourceAnswers.index(choose)}" if @sourceAnswers.include?(choose)
        end
        @order.delete(nil)
        @order.delete("")
        puts "Order is #{@order}"

        @parameters[:order] = @order
      end
      if %I(caption choice multichoice veracity).include? @parameters[:type]
        puts 'Converting array into |string|'
        puts @answer
        @answer = eval(@answer)
        unless @answer.nil?
          @answer.delete('')
          @answer = @answer.join('|')
          puts "Conversion complete!"
          puts @answer.to_s
        else
          'No answer was selected.'
          @answer = ""
        end
      end
      @answer[0] = '' if @answer[0] == '|'

      @ans.update(attempt: @answer,
                  parameters: @parameters )
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
        @current_quiz = Quiz.find_by(id: params[:id])
        @grade = Float(0)

        @quiz_start = Time.at(@current_quiz.timestarted)
        @quiz_end = Time.at(@quiz_start.to_i + @quiz_durations[@current_quiz.level]*60)
        @duration = Time.at(@current_quiz.timeended - @current_quiz.timestarted)

        @answers_array = eval(@current_quiz.answerarray)
        @answer_objects = []
        @answers_array.each do |a_id|
            @answer_objects << Answer.find_by(id: a_id)
        end

        shift
        @answer_objects.each do |anst|
            quest = @question_objects[@answer_objects.index(anst)]
            @parameters = eval(anst.parameters)
            if @parameters[:type] == :formula
                puts @parameters[:data].to_s
                puts quest.answer.to_s
                truth = eval(eval(%Q(sprintf('#{quest.answer}',#{@parameters[:data].join(',')}))))
                @grade += anst.grade if anst.attempt.to_i == truth
            elsif %I(veracity).include? @parameters[:type]
                chooses = Choice.select(:decoy).where(question: quest.id).order(:id)
                chooses = chooses.map { |choice| choice.decoy }
                @choices = []
                @parameters[:order].each do |choice|
                    @choices << if choice.class == String
                                    anst.attempt.split('|')[choice.to_i]
                                else
                                    chooses[choice]
                                end
                end
                @choices.delete(nil)
                puts @choices.to_s
                puts @choices.intersection(quest.answer.split('|')).to_s
                puts anst.attempt.split('|').to_s
                @grade += anst.grade if @choices.intersection(quest.answer.split('|')).sort == anst.attempt.split('|').sort
            else
                if @parameters.include?(:strict_order)
                    @grade += anst.grade if anst.attempt.split('|') == quest.answer.split('|')
                else
                    @grade += anst.grade if anst.attempt.downcase.split('|').sort == quest.answer.downcase.split('|').sort
                end
            end
        end

         @fanfare = if @grade < 7
                        helpers.audio_path("failhard.ogg")
                    elsif @grade < 9.5
                        helpers.audio_path("fail.ogg")
                    elsif @grade < 14.5
                        helpers.audio_path("succeed.ogg")
                    elsif @grade < 18
                        helpers.audio_path("succeedhard.ogg")
                    elsif @grade < 20
                        helpers.audio_path("succeedharder.ogg")
                    else
                        helpers.audio_path("succeedhardest.ogg")
                    end
    end
 
end