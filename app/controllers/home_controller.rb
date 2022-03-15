class HomeController < ApplicationController
    def index
    end

    def data
        @subjects = Subject.select(:title)
    end

    def submit_question
        @question = params[:question]
        unless params[:image] == "" || params[:image].nil?
            @question << "<br><img class='qImage' src='#{params[:image]}'>"
        end

        Question.create(question: @question,
        questiontype: params[:type],
        answer: params[:answer],
        choices: params[:choices],
        subject: params[:subject],
        level: params[:level].to_i,
        tags: '[]',
        frequency: 0,
        parameters: '[]'
    )
    redirect_to data_path
    end

    def about
    end
end