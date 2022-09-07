class Api::JourneysController < ApplicationController
  before_action :set_journey, only: %i[ show edit update destroy ]

  # GET /journeys or /journeys.json
  def index
    @journeys = Journey.all
  end

  # GET /journeys/1 or /journeys/1.json
  def show
  end

  # GET /journeys/new
  def new
    @journey = Journey.new
  end

  # GET /journeys/1/edit
  def edit; end

  # POST /journeys or /journeys.json
  def create
    starting_time = Time.zone.now
    journey = Journey.new(duration: 0, stat_id: current_user.stat.id, start_time: starting_time, soundtrack_id: Soundtrack.order(Arel.sql('RANDOM()')).limit(1).first.id)
    journey.save!
    [10, 20, 31, 38, 54, 75].each_with_index do |change_time, index|
      calculated_time = starting_time.to_time.to_i + (change_time * 60)
      QC.enqueue_at(Time.at(calculated_time), 'journey_update', journey.id.to_s, (index + 2).to_s)
    end

    Subject.where(evaluable: 1).order(title: :asc).each do |subject|
      chair = Chair.create(subject_id: subject.id, journey_id: journey.id, format: rand(0..1).round)
      chair.update(dissertation: rand(0.0..20.0).round(2)) unless subject.questions.where(level: 3).exists?
    end
    current_user.stat.update(journey_id: journey.id)
  end

  # PATCH/PUT /journeys/1 or /journeys/1.json
  def update
    respond_to do |format|
      if @journey.update(journey_params)
        format.html { redirect_to journey_url(@journey), notice: "Journey was successfully updated." }
        format.json { render :show, status: :ok, location: @journey }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /journeys/1 or /journeys/1.json
  def destroy
    @journey.destroy

    respond_to do |format|
      format.html { redirect_to journeys_url, notice: "Journey was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journey
      @journey = Journey.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def journey_params
      params.fetch(:journey, {})
    end
end
