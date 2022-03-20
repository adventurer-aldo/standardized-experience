module QuizHelper

    def sort_choices
        @choices = []
        @qChoices = Choice.select(:decoy).where(question:@question.id)
        @qChoices = @qChoices.(&:decoy)
        @qAnswers = @question.answer.split('|')
        if @type == :veracity
            rand(0..@qAnswers.size).times { @choices << (@qAnswers - @choices).sample }
            @min = 0
        else
            @choices += @qAnswers
            @min = 1
        end
        rand(@min..@qChoices.size).times { @choices << (@qChoices - @choices).sample }
        @choices << (@qAnswers + @qAnswers).sample unless @choices.size > 0
        @choices.shuffle!
        return @choices
    end

    def order_choices
        @choices = []
        @answer = @question.answer.split("|")
        @realChoices = Choice.select(:decoy).where(question:@question.id).order(:id)
        @realChoices = @realChoices.(&:decoy)
        @parameters[:order].each do |choice|
            @choices << if choice.class == String
                            @answer[choice.to_i]
                        else
                            @realChoices[choice]
                        end
        end
    end

end