class Api::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[ show edit update destroy ]

  # GET api/questions or api/questions.json
  def index
    query = current_user.stat.questions.where("question LIKE ?
      AND EXISTS (SELECT 1 FROM unnest(answer) AS ans WHERE ans LIKE ?)
      AND#{params[:level] == '' ? ' NOT' : ''} level=?",
      "%#{params[:question]}%", 
      "%#{params[:answer]}%", params[:level] == '' ? 5000 : params[:level]
    ).order(question: params[:order]).map do |question|
      {
        id: question.id, subject: question.subject_id, question_types: question.question_types, level: question.level,
        question: question.question, answer: question.answer, tags: question.tags, parameters: question.parameters,
        choices: question.choices.map { |choice| [choice.id, choice.decoy, choice.veracity]}
      }
    end
    @questions = query.each_slice(16).to_a
    subjects = if current_user.stat.questions_pref.zero?
                 current_user.stat.subjects
               else
                 current_user.stat.subjects.or(Subjects.where(visibility: 0))
               end.map { |subject| [subject.id, subject.title] }

    page = if params[:page].to_i && params[:page].to_i > @questions.size
             @questions.size - 1
           elsif params[:page]
             params[:page].to_i - 1
           else
             0
           end

    render json: { page: page, pages: @questions.size, subjects: subjects, questions: @questions[page].nil? ? [] : @questions[page] }
  end

  # GET api/questions/1 or api/questions/1.json
  def show; end

  # GET api/questions/new
  def new
    @question = Question.new
  end

  # GET api/questions/1/edit
  def edit
  end

  # POST api/questions or api/questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to question_url(@question), notice: "Question was successfully created." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT api/questions/1 or api/questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to question_url(@question), notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE api/questions/1 or api/questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url, notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.fetch(:question, {}).permit(:subject_id, :question, :level, :stat_id, question_types: [], answer: [], tags: [], parameters: [])
    end
end
