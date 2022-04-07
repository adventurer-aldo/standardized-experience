module QuizHelper

    def sort_choices
        @choices = []
        @qChoices = Choice.select(:decoy).where(question:@question.id)
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
        @answer = @question.answer.split("|")
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
        @que = eval(%Q(sprintf("#{@question.question.gsub(/#<(.*?)>/,"%d")}",#{@data.join(',')})))
        @temp = ""

        @in_maths.times do |i|
            @temp = "#{@que[/~&(.*?)&/,1]}"
            @que[@que.index("~&")..(@que.index("~&")+"#{@que[/~&(.*?)&/]}".length)] = eval(@temp).to_s
        end
    end
end