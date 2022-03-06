module QuizHelper
=begin

            @questionObjects.each do |quizQuestion|
                case eval("[#{quizQuestion.questiontype}]").sample
                when :open
                when :choice
                when :multichoice
                when :veracity
                when :caption
                when :table
                when :template
                end
            end
=end
end