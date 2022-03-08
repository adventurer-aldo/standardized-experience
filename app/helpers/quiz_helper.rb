module QuizHelper

    def sort_choices
        @choices = []
        @qChoices = @question.choices.split('|')
        rand(1..@qChoices.size).times { @choices << (@qChoices - @choices).sample }
        @choices += @question.answer.split('|')
        @choices.shuffle!
        return @choices
    end

end