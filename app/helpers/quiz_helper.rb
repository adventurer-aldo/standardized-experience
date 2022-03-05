module QuizHelper
    
    def makeQuiz(array)
        @questionObjects = []
        array.each do |answerID|
            @answerObject = Answer.where(id: answerID)
            @questionObjects << Question.where(id: @answerObject.questionid)
        end
        
        @questionObjects.each do |quizQuestion|
        end

    end

end