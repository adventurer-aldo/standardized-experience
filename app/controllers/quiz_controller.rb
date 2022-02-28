class QuizController < ApplicationController

    def index
        @journeyProgress = Statistic.select(:current_journey_progress)[0]

        if params[:subject].nil? || Question.select(:subject).exists?(subject: params[:subject])
            params[:subject] = Subject.order(Arel.sql('RANDOM()')).limit(1)[0]['title']
        end

        if params[:level].nil? || (@journeyProgress != params[:level] && @journeyProgress != 0)
            params[:level] = 0
        end

    end

    def result
    end
end