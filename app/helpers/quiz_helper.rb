module QuizHelper

    def sort_choices
        @choices = []
        @qChoices = @question.choices.split('|')
        rand(1..@qChoices.size).times { @choices << (@qChoices - @choices).sample }
        @choices += @question.answer.split('|')
        @choices.shuffle!
        return @choices
    end

    def order_choices
        @choices = []
        @answer = @question.answer.split("|")
        @choices = @question.choices.split("|")
        @parameters[:order].each do |choice|
            if choice.class == String
                @choices[@parameters[:order].index(choice)] = @answer[choice.to_i]
            else
                @choices[@parameters[:order].index(choice)] = @choices[choice]
            end
        end
    end

end