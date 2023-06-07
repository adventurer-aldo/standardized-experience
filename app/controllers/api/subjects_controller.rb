class Api::SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject, only: %i[ show edit update destroy ]

  # GET /subjects or /subjects.json
  def index
    stat = current_user.stat
    query = if stat.subjects_pref.zero?
              stat.subjects.or(Subject.where(visibility: 0))
            else
              stat.subjects
            end.where("title LIKE ? AND description LIKE ? AND#{params[:formula] == '' ? ' NOT' : ''} formula=? AND#{params[:practical] == '' ? ' NOT' : ''} practical=?",
                      "%#{params[:title]}%", "%#{params[:description]}%", params[:formula] == '' ? 5000 : params[:formula], params[:practical] == '' ? 2 : params[:practical]).order(title: params[:order]).map do |subject|
      { id: subject.id, title: subject.title, description: subject.description, formula: subject.formula,
        questions: subject.questions.size, job_type: subject.job_type, practical: subject.practical,
        visibility: subject.visibility.to_s, creator: subject.stat_id, creator_name: subject.stat.user.username,
        allow_foreign: subject.allow_foreign.to_s, tags: subject.questions.map(&:tags).flatten.uniq,
        evaluable_tags: stat.evaluables.where(subject_id: subject.id)&.first&.tags,
        evaluable_id: stat.evaluables.where(subject_id: subject.id)&.first&.id,
        evaluable_focus: stat.evaluables.where(subject_id: subject.id)&.first&.focus }
    end
    @subjects = query.each_slice(6).to_a
    page = if params[:page].to_i && params[:page].to_i > @subjects.size
             @subjects.size - 1
           elsif params[:page]
             params[:page].to_i
           else
             0
           end

    render json: { results: query.size, page:, pages: @subjects.size, subjects: (@subjects[page].nil? ? [] : @subjects[page]) }
  end

  # GET /subjects/1 or /subjects/1.json
  def show
    render json: { subject: { id: @subject.id, title: @subject.title, description: @subject.description, formula: @subject.formula,
                              questions: @subject.questions.size, job_type: @subject.job_type, practical: @subject.practical,
                              visibility: @subject.visibility.to_s, creator: @subject.stat_id, creator_name: @subject.stat.user.username,
                              allow_foreign: @subject.allow_foreign.to_s } }
  end

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
    params.fetch(:subject, {}).permit(:evaluable, :visibility, :title, :description, :formula, :job_type, :practical, :stat_id, :allow_foreign)
  end
end
