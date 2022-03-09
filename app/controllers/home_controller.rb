class HomeController < ApplicationController
    def index
    end

    def submit_question
        Question.create(question: params[:question],
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