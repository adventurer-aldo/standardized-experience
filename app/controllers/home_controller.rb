class HomeController < ApplicationController
    def index
        @journeyProgress = Journey.find_by(id: Stat.first.current_journey).level
        @ost = if @journeyProgress == 0
                   'https://cdn.discordapp.com/attachments/962345513825468456/964951311831416922/home.ogg'
               elsif @journeyProgress == 1
                   'https://cdn.discordapp.com/attachments/962345513825468456/964951312083062844/prep.ogg'
               elsif @journeyProgress < 4
                   'https://cdn.discordapp.com/attachments/962345513825468456/964951311294537768/prep2.ogg'
               elsif @journeyProgress > 3
                   'https://cdn.discordapp.com/attachments/962345513825468456/964951311542026250/prepexam.ogg'
               end

        @tip = Question.all.order(Arel.sql('RANDOM()')).limit(1)

    end

    def question
        @subjects = Subject.select(:title).order(title: 'asc')
    end

    def subject
        @subjects = Subject.all.order(title: :asc)
    end

    def submit_subject
        case params[:operation]
        when 'add'
            Subject.create(
                title: params[:title], 
                preferredformat: params[:preferredformat],
                difficulty: rand(1..5)
            )
        when 'delete'
            Question.destroy_by(subject: params[:id].to_i)
            Subject.destroy_by(id: params[:id].to_i)
        end
        redirect_to subject_path
    end

    def submit_question
        @old_question = Question.last
        @new_question = Question.create(
            question: params[:question],
            questiontype: "[#{params[:type]}]",
            answer: params[:answer],
            subject: params[:subject],
            level: params[:level].to_i,
            tags: '[]',
            frequency: 0,
            parameters: "[#{params[:parameters].join(',')}]"
                                      )

        case params[:reuse_image]
        when '0'
            @new_question.image.attach(params[:image]) unless params[:image].nil?
        when '1'
            @new_question.image.attach(@old_question.image.blob) unless @old_question.image.nil?
        end

        if !params[:choice].nil?
            params[:choice].uniq.each do |choice|
                Choice.create(decoy: choice, question: @new_question.id)
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

    def about; end

    def new_journey
        subjects = Subject.all.order(title: :asc)
        journey = Journey.create(type: 'short', start_time: Time.now)

        subjects.each do |subject|
            Chair.create(subject: subject.id, journey: journey.id, format: rand(0..1).round)
        end

        Stat.last.update(current_journey: journey.id)
    end

end
