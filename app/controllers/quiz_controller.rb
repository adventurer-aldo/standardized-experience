class QuizController < ApplicationController

    def index
        @journeyProgress = Statistic.select(:current_journey_progress)[0]

        if params[:subject].nil? || Question.select(:subject).exists?(subject: params[:subject])
            params[:subject] = Subject.order(Arel.sql('RANDOM()')).limit(1)[0]['title']
        end

        if params[:level].nil? || (@journeyProgress != params[:level] && @journeyProgress != 0)
            params[:level] = 0
        end
        
        params[:level] == 0 ? @journey = 0 : @journey = Statistic.select(:active_journey_id)[0]

        baseQuery = Question.select.where(%Q(subject='#{params[:subject]}')).order(Arel.sql('RANDOM()'))
        
        case level
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
        @fullQuery.each do |query|
            @questionsArray << query['id']
        end

        @questionsArray.each do |n|
            @tempQuestion = Question.where(id: n)
            @tempQuestion.frequency += 1
            @tempQuestion.save
        end

        Quiz.create(
            subject: params[:subject],
            name: "", surname: "",
            journey: @journey,
            question: @questionsArray.to_s)
    end

    def result
        
    end
end