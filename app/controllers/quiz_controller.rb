class QuizController < ApplicationController
  before_action :setup

  #=======================================================================================
  # -- SETUP
  # Common for all methods of the controller. Defines common variables such as the formats
  # names and the endings of the tests, as wll as the time the quizzes will take.
  #=======================================================================================
  def setup
    @formats = 0..1
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
  # -- INDEX
  # The main page. Takes parameters LEVEL and SUBJECT before choosing which questions to
  # show. Randomly selects questions based on those parameters and takes care of other
  # extra transitions.
  #=======================================================================================

  def index
    @journey = Stat.last.journey

    @subject = if params[:subject] || Subject.where(title: params[:subject]).exists?
                 Subject.where(title: params[:subject]).first
               else
                 params[:subject] = Subject.all.order(Arel.sql('RANDOM()')).limit(1).first
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

    base_query = Question.where(subject_id: params[:subject]).order(Arel.sql('RANDOM()')).group(:id)

    all_questions = case @level
                    when 0
                      base_query.limit(rand(3..10)) # Prática
                    when 1
                      base_query.where(level: 1).limit(rand(10..35)) # Teste 1
                    when 2
                      base_query.where(level: 2).limit(rand(10..28)) + base_query.where(level: 1).limit(rand(0..7)) # Teste 2
                    when 3
                      base_query.where.not(level: [3, 4]).limit(rand(10..40)) # Reposição
                    when 4
                      base_query.where(level: 3).limit(rand(10..40)) # Dissertação
                    when 5
                      base_query.where(level: 4).limit(rand(5..30)) + base_query.where.not(level: [3,4]).limit(rand(10..20)) # Exame
                    when 6
                      base_query.limit(rand(50..100)) # Recorrência
                    end

    @ost =  case @level
            when 0
              [@journey.soundtrack.practice, '']
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

    @full_query = all_questions.shuffle

    @questions_array = []
    @answers_array = []
    @full_query.each do |query|
      @questions_array << query.id
    end
    
    quiz = Quiz.create(
      subject_id: @subject.id,
      first_name: '', last_name: '',
      journey_id: @journey.id,
      start_time: Time.now,
      format: @format,
      level: @level
    )

    @full_query.each do |question|
      updated_frequency = question.frequency
      updated_frequency[0] += 1
      question.update(frequency: updated_frequency)
      type = question.question_types.sample
      calculated_variables = []

      case type
      when 'choice', 'multichoice', 'veracity'
        choices = question.choices.map(&:id).map(&:to_s)
        question.answer.each_with_index do |_choice_answer, index|
          choices.push("a#{index}")
        end
        choices.shuffle!
        choices = choices[0..rand(1..choices.size).to_i] if type == 'veracity'
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
        quiz_id: quiz.id,
        attempt: '',
        question_id: question.id,
        grade: (Float(20) / @full_query.size),
        question_type: type,
        variables: calculated_variables
      )
    end

    @quiz_start = quiz.start_time.to_time
    @quiz_end = Time.at(@quiz_start.to_i + @quiz_durations[@level] * 60)
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
        @order = []

        @choices.each do |choose|
          @order << @sourceChoices.index(choose) if @sourceChoices.include?(choose)
          @order << "#{@sourceAnswers.index(choose)}" if @sourceAnswers.include?(choose)
        end

        @parameters[:order] = @order
      end
      if %I(caption choice multichoice veracity).include? @parameters[:type]
        @answer = eval(@answer)
        unless @answer.nil?
          @answer.delete('')
          @answer = @answer.join('|')
        else
          @answer = ''
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
        @quiz = Quiz.find_by(id: params[:id].to_i)
        @grade = helpers.grade(@quiz)

        @duration = Time.at(@quiz.start_time.to_time - @quiz.end_time.to_time)

        @answers_array = eval(@current_quiz.answerarray)
        @answer_objects = []
        @answers_array.each do |a_id|
            @answer_objects << Answer.find_by(id: a_id)
        end

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