class QuizController < ApplicationController
    before_action :setup

    #=======================================================================================
    # -- SETUP
    # Common for all methods of the controller. Defines common variables such as the formats
    # names and the endings of the tests, as wll as the time the quizzes will take.
    #=======================================================================================
    def setup
        @formats = 1..1
        @ending = [""]

        @testName = [
            "Exercícios",
            "Teste 1",
            "Teste 2",
            "Teste de Reposição",
            "Exame Normal",
            "Exame de Recorrência"
        ]

        @quizDurations = [5,9,9,10,15,20]

        case @formats
        when 0
            @ending = ["RR/BM",'center']
        when 1
            @testName[1] = "1º Teste de Frequência"
            @testName[2] = "2º Teste de Frequência"
        end

        @ost = {
        0 => ["https://cdn.discordapp.com/attachments/962345513825468456/964949971344441405/prac.ogg",""],
        1 => ["https://cdn.discordapp.com/attachments/962345513825468456/964949973357707304/test1.ogg",
        "https://cdn.discordapp.com/attachments/962345513825468456/964949972938280970/rushtest1.ogg"],
        2 => ["https://cdn.discordapp.com/attachments/962345513825468456/964950421808484382/test2.ogg",
        "https://cdn.discordapp.com/attachments/962345513825468456/964949973147983952/rushtest2.ogg"],
        3 => ["https://cdn.discordapp.com/attachments/962345513825468456/964950421808484382/test2.ogg",
        "https://cdn.discordapp.com/attachments/962345513825468456/964949973147983952/rushtest2.ogg"],
        4 => ["https://cdn.discordapp.com/attachments/962345513825468456/964202769382793276/exam.ogg",
        "https://cdn.discordapp.com/attachments/962345513825468456/964202769064034315/rushexam.ogg"],
        5 => ["https://cdn.discordapp.com/attachments/962345513825468456/964949970941792256/examrec.ogg",
        "https://cdn.discordapp.com/attachments/962345513825468456/964202769064034315/rushexam.ogg"]
        }


    end

    

    #=======================================================================================
    # -- SHIFT
    # Creates an array of Question objects from the database that matches each ID of the
    # Answers array.
    #=======================================================================================
    def shift
        puts "Shifting"
        @questionObjects = []
        @answerObjects = []
        @answersArray.each do |answerID|
            @answerObject = Answer.find_by(id: answerID)
            puts @answerObject.to_s
            @answerObjects << @answerObject
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
        @journeyProgress = Stat.first.activejourneylevel

        if params[:subject].nil? || Question.select(:subject).exists?(subject: params[:subject]) == false
            params[:subject] = Subject.all.order(Arel.sql('RANDOM()')).limit(1).first.title
        end

        if !params[:level] || (@journeyProgress <= params[:level].to_i && @journeyProgress > 0)
            params[:level] = 0
        else
            params[:level] = params[:level].to_i
        end


        if params[:level] == 0
            @format = rand(@formats).round(0)
        else
            @format = Subject.find_by(title: params[:subject]).preferredformat
            @format = 0 unless @formats.include?(@format)
        end
        
        params[:level] == 0 ? @journey = 0 : @journey = Stat.first.activejourneyid

        baseQuery = Question.select(:id, :tags).where(%Q(subject='#{params[:subject]}')).order(Arel.sql('RANDOM()')).group(:id)
        
        case params[:level]
        when 0
            allQuestions = baseQuery.limit(rand(3..10)) #)
        when 1
            allQuestions = baseQuery.where('level=1').limit(rand(10..35))
        when 2 
            allQuestions = baseQuery.where('level=2').limit(rand(10..28)) + baseQuery.where('level=1').limit(rand(0..7))
        when 3
            allQuestions = baseQuery.where.not('level=3').limit(rand(10..40))
        when 4
            allQuestions = baseQuery.where('level=3').limit(rand(5..30)) + baseQuery.where.not('level=3').limit(rand(10..20))
        when 5
            allQuestions = baseQuery.limit(rand(50..100))
        end
        
        @fullQuery = allQuestions.shuffle

        @questionsArray = []
        @answersArray = []
        @fullQuery.each do |query|
            @questionsArray << query.id
        end

        @questionsArray.each do |n|
            @tempQuestion = Question.find_by(id: n)
            @tempQuestion.update(frequency: (@tempQuestion.frequency += 1))
            parameters = {}
            parameters[:type] = eval(@tempQuestion.questiontype).sample

            if %I(formula).include? parameters[:type]
                que = (@tempQuestion.question).dup
                randoms = que.count("#")
                temp = []
                puts "#{randoms} times!"
                randoms.times do 
                    temp << "#{que[/#£(.*?)§/,1]}".split(',')
                    puts "Adding [#{que[/#£(.*?)§/,1]}]"
                    que[que.index("#£")..que.index("§")] = ""
                end
                puts temp.to_s
                temp.map! do |n|
                    c = n.map(&:to_f)
                    puts c.to_s
                    puts n.to_s
                    if n.size == 1
                        Float(rand(1..(c.first))).round(2)
                    elsif n.size == 2
                        Float(rand(c.first..c.last)).round
                    elsif n.size == 3
                        Float(rand(c.first..c.last)).round(1)
                    elsif n.size == 4
                        Float(rand(c.first..c.last)).round(2)
                    elsif n.size == 5
                        Float(rand(c.first..c.last)).round(3)
                    else
                        Float(rand(20000)).round(2)
                    end
                end
                
                parameters[:data] = temp
            end

            @answer = Answer.create(
                attempt: "",
                questionid: n,
                grade: (Float(20)/@questionsArray.size),
                parameters: parameters
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

        @stats = Stat.first
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
            @ans = Answer.find_by(id: answer_id)
            @parameters = eval(@ans.parameters)
            @answer = "#{params[:answer]["#{@answers.index(answer_id)}"]}"
            if %I(choice multichoice veracity).include? @parameters[:type]
                @que = Question.find_by(id: @ans.questionid)
                @sourceAnswers = @que.answer.split("|")
                @sourceChoices = (Choice.select(:decoy).where(question: @que.id).order(:id)).map{|n| n.decoy }
                @choices = eval(params[:choices][@answers.index(answer_id).to_s])
                puts "Choices are #{@choices}"
                @order = []

                @choices.each do |choose|
                    @order << @sourceChoices.index(choose) if @sourceChoices.include?(choose)
                    @order << "#{@sourceAnswers.index(choose)}" if @sourceAnswers.include?(choose)
                end
                @order.delete(nil)
                @order.delete("")
                puts "Order is #{@order}"

                @parameters[:order] = @order
            end
            if %I(caption choice multichoice veracity).include? @parameters[:type]
                puts "Converting array into |string|"
                puts @answer
                @answer = eval(@answer)
                unless @answer.nil?
                    @answer.delete("")
                    @answer = @answer.join('|')
                    puts "Conversion complete!"
                    puts @answer.to_s
                else
                    "No answer was selected."
                    @answer = ""
                end
                
            end
            @answer[0] = "" if @answer[0] == "|"

            @ans.update(attempt: @answer,
            parameters: @parameters.to_s )
             
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
        @grade = Float(0)

        @quizStart = Time.at(@currentQuiz.timestarted)
        @quizEnd = Time.at(@quizStart.to_i + @quizDurations[@currentQuiz.level]*60)
        @duration = Time.at(@currentQuiz.timeended - @currentQuiz.timestarted)

        @answersArray = eval(@currentQuiz.answerarray)
        @answerObjects = []
        @answersArray.each do |a_id|
            @answerObjects << Answer.find_by(id: a_id)
        end

        shift
        @answerObjects.each do |anst|
            quest = @questionObjects[@answerObjects.index(anst)]
            @parameters = eval(anst.parameters)
            if @parameters[:type] == :formula
                puts @parameters[:data].to_s
                puts quest.answer.to_s
                truth = eval(eval(%Q(sprintf('#{quest.answer}',#{@parameters[:data].join(',')}))))
                @grade += anst.grade if anst.attempt.to_i == truth
            elsif %I(veracity).include? @parameters[:type]
                chooses = Choice.select(:decoy).where(question: quest.id).order(:id)
                chooses = chooses.map { |choice| choice.decoy }
                @choices = []
                @parameters[:order].each do |choice|
                    @choices << if choice.class == String
                                    anst.attempt.split('|')[choice.to_i]
                                else
                                    chooses[choice]
                                end
                end
                @choices.delete(nil)
                puts @choices.to_s
                puts @choices.intersection(quest.answer.split('|')).to_s
                puts anst.attempt.split('|').to_s
                @grade += anst.grade if @choices.intersection(quest.answer.split('|')).sort == anst.attempt.split('|').sort
            else
                if @parameters.include?(:strict_order)
                    @grade += anst.grade if anst.attempt.split('|') == quest.answer.split('|')
                else
                    @grade += anst.grade if anst.attempt.downcase.split('|').sort == quest.answer.downcase.split('|').sort
                end
            end
        end

         @fanfare = if @grade < 7
                        helpers.audio_path("failhard.ogg")
                    elsif @grade < 9.5
                        helpers.audio_path("fail.ogg")
                    elsif @grade < 14.5
                        helpers.audio_path("succeed.ogg")
                    elsif @grade < 18
                        helpers.audio_path("succeedhard.ogg")
                    elsif @grade < 20
                        helpers.audio_path("succeedharder.ogg")
                    else
                        helpers.audio_path("succeedhardest.ogg")
                    end
    end
 
end