class QuizController < ApplicationController

    @formats = 0..1
    @ending = ""

    case @formats
    when 0
        @ending = ""
    end

    def index
        @journeyProgress = Statistic.first["activejourneylevel"]
        @testName = ""

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
            format: @format)
        
        @stats = Statistic.first
        @stats.lastquizid = @currentQuiz.id
        @stats.totalquizzes += 1
        @stats.save

    end

    def result
        
    end
end