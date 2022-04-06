class HomeController < ApplicationController
    def index
        
    end

    def data
        @subjects = Subject.select(:title).order(title: 'asc')

        anatos = Question.where("subject LIKE '%Prática%'")
        anatos.each do |question|
            puts "Beginning migration of ibb to b2cloud."
            @link = ""
            @prev_question = nil
            unless question.image.attached?
                puts "Found one question without an attached image."
                sauce = question.question[/src='(.*?)'/,1]
                if sauce == nil
                    puts "Sauce had apparently double quotation. Issue solved."
                    sauce = question.question[/src="(.*?)"/,1]
                end
                if sauce == @link
                    puts "It shares the image from the previous question. This will be simple..."
                    question.image.attach(@prev_question.image.blob)
                    puts "DONE!"
                else
                    puts "Gotta create a new image for this one..."
                    @link = sauce
                    downloaded_sauce = URI.open(URI.parse(sauce))
                    question.image.attach(io: downloaded_sauce, filename: "image.png")
                    puts "Done!"
                end
                predicament = question.question[/<br><img(.*?)>/]
                if predicament == nil
                    predicament = question.question[/<img(.*?)>/]
                end
                fix = question.question.dup
                fix[fix.index(predicament)..(fix.index(predicament)+predicament.size)] = ""
                puts "Removed the html tags."
                question.update(question: fix)
                @prev_question = question
                puts "Saved previous question and moving on..."
            end
        end
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
        case params[:reuse_image]
        when "0"
            @newQuestion.image.attach(params[:image]) unless params[:image] == nil
        when "1"
            @newQuestion.image.attach(@oldQuestion.image.blob) unless @oldQuestion.image == nil
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
        cookies[:reuse_image] = params[:reuse_image]

        redirect_to data_path
    end

    def about

    end
end
