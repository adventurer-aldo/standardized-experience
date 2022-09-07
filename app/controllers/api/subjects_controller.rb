class Api::SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject, only: %i[ show edit update destroy ]

  # GET /subjects or /subjects.json
  def index
    @subjects = current_user.stat.subjects.or(Subject.where(visibility: 0)).order(title: :asc).map do |subject|
      {
        id: subject.id, title: subject.title, description: subject.description,
        formula: subject.formula, questions: subject.questions.size,
        job_type: subject.job_type, practical: subject.practical, visibility: subject.visibility.to_s,
        creator: subject.stat_id, creator_name: subject.stat.user.username
      }
    end.each_slice(6).to_a

    @page = if params[:page].to_i && params[:page].to_i > @subjects.size
              @subjects.size - 1
            elsif params[:page]
              params[:page].to_i
            else
              0
            end

    render json: { page: @page, pages: @subjects.size, subjects: @subjects[@page] }
  end

  # GET /subjects/1 or /subjects/1.json
  def show; end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit; end

  # POST /subjects or /subjects.json
  def create
    @subject = Subject.new(subject_params)

    @subject.save
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    render(json: @subject) if @subject.update(subject_params)
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    @subject.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subject
    @subject = Subject.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subject_params
    params.fetch(:subject, {}).permit(:evaluable, :visibility, :title, :description, :formula, :job_type, :practical, :stat_id)
  end
end
