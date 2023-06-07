class Api::LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show edit update destroy ]

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons or /lessons.json
  def create
    subject = Subject.find_by(id: lesson_params[:subject_id].to_i)
    quiz = current_user.stat.quizzes.create!(subject_id: subject.id,first_name: '', last_name: '',
                                             journey_id: current_user.journeys.last.id,
                                             start_time: Time.zone.now,
                                             format: 0, level: 0)

    ([true, false].sample ? subject.questions.limit(rand(20..40)) : subject.questions).where('? = ANY(tags)', lesson_params[:tag]).shuffle.each do |question|
      question.answers.create!(quiz_id: quiz.id, grade: 0, question_type: question.question_types.sample)
    end

    @lesson = current_user.stat.lessons.new(tag: lesson_params[:tag], quiz_id: quiz.id, subject_id: subject.id)

    render json: @lesson if @lesson.save
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to lesson_url(@lesson), notice: "Lesson was successfully updated." }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to lessons_url, notice: "Lesson was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lesson_params
    params.fetch(:lesson, {}).permit(:tag, :subject_id)
  end
end
