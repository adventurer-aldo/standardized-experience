class Api::QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show edit update destroy ]

  # GET api/questions or api/questions.json
  def index
    @questions = if params[:subject]
                   Question.where(subject_id: params[:subject])
                 else
                   Question.all
                 end.order(id: :desc).each_slice(16).to_a

    @page = if params[:page].to_i && params[:page].to_i > @questions.size
              @questions.size - 1
            elsif params[:page]
              params[:page].to_i - 1
            else
              0
            end

    @questions[@page].map! do |question|
      { id: question.id, question: question.question, subject: question.subject_id,
        answer: question.answer, tags: question.tags, level: question.level,
        frequency: question.level, image: question.image.url,
        creator: question.stat.user.username, evaluable: question.evaluable }
    end

    render json: { page: @page, pages: @questions.size, questions: @questions[@page] }
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
      params.fetch(:question, {})
    end
end
