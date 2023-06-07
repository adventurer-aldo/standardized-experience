class Api::StatsController < ApplicationController
  before_action :set_stat, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /stats or /stats.json
  def index
    stat = current_user.stat
    @stats = {
      id: stat.id, skip_dissertation: stat.skip_dissertation, long_journey: stat.long_journey,
      lenient_answer: stat.lenient_answer, lenient_name: stat.lenient_name,
      avoid_negative: stat.avoid_negative, focus_level: stat.focus_level,
      questions_pref: stat.questions_pref, picture: stat.picture, theme_id: stat.theme_id,
      username: current_user.username, evaluables: stat.evaluables.map(&:subject_id)
    }

    render json: @stats
  end

  # GET /stats/1 or /stats/1.json
  def show
  end

  # GET /stats/new
  def new
    @stat = Stat.new
  end

  # GET /stats/1/edit
  def edit
  end

  # POST /stats or /stats.json
  def create
    @stat = Stat.new(stat_params)

    respond_to do |format|
      if @stat.save
        format.html { redirect_to stat_url(@stat), notice: "Stat was successfully created." }
        format.json { render :show, status: :created, location: @stat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stats/1 or /stats/1.json
  def update
    return unless stat_params['evaluables']
    ids = stat_params['evaluables'].map(&:to_i)
    @stat.evaluables.where.not(subject_id: ids).destroy_all
    ids.each do |evaluable|
      @stat.evaluables.find_or_create_by(subject_id: evaluable)
    end

    # @stat.update(stat_params)
  end

  # DELETE /stats/1 or /stats/1.json
  def destroy
    @stat.destroy

    respond_to do |format|
      format.html { redirect_to stats_url, notice: "Stat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stat
      @stat = Stat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stat_params
      params.fetch(:stat, {}).permit(:focus_level, :avoid_negative, :long_journey, evaluables: [])
    end
end
