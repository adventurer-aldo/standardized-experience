class LessonController < ApplicationController

  def index
    redirect_to(classroom_path) unless params[:id] && Lesson.where(id: params[:id], grade: nil).exists?

    @lesson = Lesson.find_by(id: params[:id])
    @points = @lesson.quiz.answers.map do |answer|
      { id: answer.id, attempt: answer.attempt, question_id: answer.question_id,
        question: answer.question.question, correct: false, parameters: answer.question.parameters,
        question_type: answer.question_type, answers: answer.question.answer,
        choices: answer.question.choices.map { |choice| [choice.texts, choice.image&.url] } }
    end
  end

end
