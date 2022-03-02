class QuizController < ApplicationController

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
            allQuestions = baseQuery.limit(rand(5..10))
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
                questionid: n
            )
            @answersArray << @answer.id
        end

        @currentQuiz = Quiz.create(
            subject: params[:subject],
            name: "", surname: "",
            journey: @journey,
            answerarray: @answersArray.to_s,
            timestarted: Time.now.to_i,
            timeended: Time.now.to_i,
            format: @format,
            level: params[:level])
        
        stats = Statistic.first
        newLastQuizID = @currentQuiz.id
        newTotalQuizzes = stats.totalquizzes += 1
        
        stats.update(lastquizid: newLastQuizID, totalquizzes: newTotalQuizzes)

        @quizStart = Time.at(@currentQuiz.timestarted)
        @quizEnd = Time.at(@quizTime.to_i + @quizDurations*60)

    end

    def result
        
    end
end