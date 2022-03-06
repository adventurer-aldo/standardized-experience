class QuizController < ApplicationController
    before_action :setup

    #=======================================================================================
    # -- SETUP
    # Common for all methods of the controller. Defines common variables such as the formats
    # names and the endings of the tests, as wll as the time the quizzes will take.
    #=======================================================================================
    def setup
        @formats = 0..0
        @ending = ""

        @testName = [
            "Teste 1",
            "Teste 2",
            "Teste de Reposição",
            "Exame Normal",
            "Exame de Reposição"
        ]

        @quizDurations = [5,9,9,10,15,20]

        case @formats
        when 0
            @ending = "RR/BM"
        when 1
            @testName[0] = "1º Teste de Frequência"
            @testName[0] = "2º Teste de Frequência"
        end
    end

    #=======================================================================================
    # -- SHIFT
    # Creates an array of Question objects from the database that matches each ID of the
    # Answers array.
    #=======================================================================================
    def shift
        @questionObjects = []
        @answersArray.each do |answerID|
            @answerObject = Answer.find_by(id: answerID)
            @questionObjects << Question.find_by(id: @answerObject.questionid)
        end

    end

    #=======================================================================================
    # -- INDEX
    # The main page. Takes parameters LEVEL and SUBJECT before choosing which questions to
    # show. Randomly selects questions based on those parameters and takes care of other
    # extra transitions.
    #=======================================================================================
    def index
        @journeyProgress = Statistic.first["activejourneylevel"]

        if params[:subject].nil? || Question.select(:subject).exists?(subject: params[:subject])
            params[:subject] = Subject.order(Arel.sql('RANDOM()')).limit(1)[0]['title']
        end

        if params[:level].nil? || (@journeyProgress != params[:level] && @journeyProgress != 0)
            params[:level] = 0
        end

        if params[:level] = 0
            @format = rand(@formats).round(0)
        else
            @format = Subject.select(:preferredFormat).where(subject: params[:subject]).preferredFormat
            @format = 0 unless @formats.include?(@format)
        end
        
        params[:level] == 0 ? @journey = 0 : @journey = Statistic.first[:activeJourneyId]

        baseQuery = Question.select(:id, :tags).where(%Q(subject='#{params[:subject]}')).order(Arel.sql('RANDOM()')).group(:id)
        
        case params[:level]
        when 0
            allQuestions = baseQuery.limit(3) #rand(5..10)
        when 1
            allQuestions = baseQuery.where(%Q(level=1)).limit(rand(15..35))
        when 2
            allQuestions = baseQuery.where(%Q(level=1)).limit(rand(0..7)) + baseQuery.where(%Q(level=2)).limit(rand(10..28))
        when 3
            allQuestions = baseQuery.excluding(%Q(level=3)).limit(rand(10..40))
        when 4
            allQuestions = baseQuery.where(%Q(level=3)).limit(rand(5..30)) + baseQuery.excluding(%Q(level=3)).limit(rand(10..20))
        when 5
            allQuestions = baseQuery.limit(rand(50..100))
        end        
        
        @fullQuery = allQuestions.group(:tags)

        @questionsArray = []
        @answersArray = []
        @fullQuery.each do |query|
            @questionsArray << query['id']
        end
        
        @questionsArray.each do |n|
            @tempQuestion = Question.select(:frequency).where(id: n)[0]
            @tempQuestion['frequency'] += 1
            @tempQuestion.save
            
            @answer = Answer.create(
                attempt: "",
                questionid: n,
                grade: (20/@questionsArray.size)
            )
            @answersArray << @answer.id
        end

        Quiz.create(
            subject: params[:subject],
            name: "", surname: "",
            journey: @journey,
            answerarray: @answersArray.to_s,
            timestarted: Time.now.to_i,
            timeended: Time.now.to_i,
            format: @format,
            level: params[:level]
        )
        
        @currentQuiz = Quiz.last

        @stats = Statistic.first
        @stats.increment!(:lastquizid)
        @stats.increment!(:totalquizzes)

        @quizStart = Time.at(@currentQuiz.timestarted)
        @quizEnd = Time.at(@quizStart.to_i + @quizDurations[params[:level]]*60)

        shift
    end

    #=======================================================================================
    # -- SUBMIT
    # Takes forms from index and updates the database accordingly, then redirects to /result
    # to display the data.
    #=======================================================================================
    def submit
        @currentQuiz = Quiz.find_by(id: params[:quizID])
        @currentQuiz.update(timeended: Time.now.to_i)

        @answers = eval(@currentQuiz.answerarray)
        @answers.each do |answer_id|
            Answer.find_by(id: answer_id).update(attempt: "#{params[:answer]["#{@answers.index(answer_id)}"]}")
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
        @currentQuiz = Quiz.find_by(id: params[:id])

        @quizStart = Time.at(@currentQuiz.timestarted)
        @quizEnd = Time.at(@quizStart.to_i + @quizDurations[@currentQuiz.level]*60)
        @duration = Time.at(@currentQuiz.timeended - @currentQuiz.timestarted)

        @answersArray = eval(@currentQuiz.answerarray)
        @answerObjects = []
        @answersArray.each do |a_id|
            @answerObjects << Answer.find_by(id: a_id)
        end

        shift
    end
 
end