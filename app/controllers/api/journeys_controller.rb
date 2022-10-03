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
    @journey = Journey.create!(duration: 0, stat_id: current_user.stat.id, start_time: Time.zone.now,
                               soundtrack_id: Soundtrack.order(Arel.sql('RANDOM()')).limit(1).first.id)

    current_user.evaluables.map(&:subject).sort_by(&:title).each do |subject|
      chair = @journey.chairs.create(subject_id: subject.id, format: rand(0..2).round)
      chair.update(dissertation: rand(0..20.0).round(2)) unless subject.questions.where(level: 3).exists?
    end
  end

  # PATCH/PUT /journeys/1 or /journeys/1.json
  def update
    respond_to do |format|
      if @journey.update(journey_params)
        format.html { redirect_to journey_url(@journey), notice: 'Journey was successfully updated.' }
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
      format.html { redirect_to journeys_url, notice: 'Journey was successfully destroyed.' }
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
