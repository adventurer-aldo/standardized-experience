module QuizHelper

    def sort_choices
        @choices = []
        @qChoices = @question.choices.split('|')
        @qAnswers = @question.answer.split('|')
        rand(0..@qChoices.size).times { @choices << (@qChoices - @choices).sample }
        if @type == :veracity
            rand(0..@qAnswers.size).times { @choices << (@qAnswers - @choices).sample }
        else
            @choices += @qAnswers
        end
        @choices << (@qAnswers + @qAnswers).sample unless @choices.size > 0
        @choices.shuffle!
        return @choices
    end

    def order_choices
        @choices = []
        @answer = @question.answer.split("|")
        @realChoices = @question.choices.split("|")
        @parameters[:order].each do |choice|
            @choices << if choice.class == String
                            @answer[choice.to_i]
                        else
                            @realChoices[choice]
                        end
        end
    end

end