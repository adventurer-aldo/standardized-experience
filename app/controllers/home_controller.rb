class HomeController < ApplicationController
    def index
        
    end

    def data
        @subjects = Subject.select(:title).order(title: 'asc')
    end

    def submit_question
        @oldQuestion = Question.last
        @newQuestion = Question.create(question: params[:question],
        questiontype: "[#{params[:type]}]",
        answer: params[:answer],
        subject: params[:subject],
        level: params[:level].to_i,
        tags: '[]',
        frequency: 0,
        parameters: "[#{params[:parameters].join(',')}]"
        )
        case params[:old_image]
        when "0"
            @newQuestion.image.attach(params[:image]) unless params[:image] == nil
        when "1"
            @newQuestion.image.attach(@oldQuestion.image) unless oldQuestion.image == nil
        end

        unless params[:choice] == nil
            params[:choice].uniq.each do |choice|
                Choice.create(decoy: choice, question: @newQuestion.id)
            end
            cookies[:choices] = params[:choice].size
        else
            cookies[:choices] = 0
        end

        cookies[:level] = params[:level]
        cookies[:type] = params[:type]
        cookies[:subject] = params[:subject]
        cookies[:reuse_image] = params[:old_image]

        redirect_to data_path
    end

    def about

    end
end
