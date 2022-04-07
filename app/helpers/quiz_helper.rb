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
        @in_maths.times do
            @temp = "#{@que[/$$(.*?)$/,1]}"
            puts @temp.to_s
            puts "Solving [#{@que[/$$(.*?)$/,1]}]"
            @que[@que.index("$$")..(@que.index("$$")+@temp.length)] = eval(@temp).to_s
        end
    end
end