module QuizHelper

    def sort_choices
        @choices = []
        @qChoices = Choice.select(:decoy).where(question:@question.id).order(:id)
        @qChoices = @qChoices.map { |choice| choice.decoy }
        @qAnswers = @question.answer.split('|')
        if @type == :veracity
            rand(0..@qAnswers.size).times { @choices << (@qAnswers - @choices).sample }
            @min = 0
        else
            @choices += @qAnswers
            @min = 1
        end
        random = rand(@min..@qChoices.size)
        unless random.nil?
            random.times { @choices << (@qChoices - @choices).sample }
        end
        @choices << (@qAnswers + @qAnswers).sample unless @choices.size > 0
        @choices.shuffle!
        return @choices
    end

    def order_choices
        @choices = []
        @answer = @question.answer
        @realChoices = Choice.select(:decoy).where(question:@question.id).order(:id)
        @realChoices = @realChoices.map { |choice| choice.decoy }
        @parameters[:order].each do |choice|
            @choices << if choice.class == String
                            @answer[choice.to_i]
                        else
                            @realChoices[choice]
                        end
        end
    end

    def sort_solves
        @que = eval(%Q(sprintf("#{@question.question.gsub(/#£(.*?)§/,"%d")}",#{@data.join(',')})))
        @temp = ''

        @in_maths.times do
            @temp = "#{@que[/~&(.*?)&/,1]}"
            @que[@que.index("~&")..(@que.index("~&")+"#{@que[/~&(.*?)&/]}".length)] = eval(@temp).to_s
        end
    end

    def correct(answer)
        question = Question.find_by(id: answer.question)
    
        case answer.question_type.to_sym
        when :open
            if (answer.attempt.intersect?(question.answer) &&
                question.parameters.include?('strict')
               ) ||
               (answer.attempt.map(&:downcase).intersect?(question.answer.map(&:downcase)) &&
                !question.parameters.include?('strict')
               )
               return true
            end

        when :choice, :multichoice
            return true if answer.attempt.sort == question.answer.sort

        when :caption
            if (answer.attempt == question.answer &&
                question.parameters.include?('strict')
               ) ||
               (answer.attempt.map(&:downcase).sort == question.answer.map(&:downcase).sort &&
                !question.parameters.include?('strict')
               )

               return true
            end

        when :veracity
            return true if answer.attempt.intersection(question.answer) == answer.attempt

        when :formula
            condition = eval <<-RUBY, binding, __FILE__, __LINE__ + 1
            format("#{question.answer}", #{answer.variables.join(', ')})
            RUBY
            return true if condition == answer.attempt.first

        when :table
            return true

        end

        false
    end

    def grade(quiz)
        total = 0
        answers = Answer.where(quiz: quiz.id)
        answers.each do |answer|
            total += answer.grade if correct(answer) == true
        end
        total
    end

end