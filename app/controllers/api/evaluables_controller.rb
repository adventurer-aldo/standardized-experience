class Api::EvaluablesController < ApplicationController
  before_action :set_evaluable, only: %i[ show edit update destroy ]

  # GET /evaluables or /evaluables.json
  def index
    @evaluables = Evaluable.all
  end

  # GET /evaluables/1 or /evaluables/1.json
  def show
  end

  # GET /evaluables/new
  def new
    @evaluable = Evaluable.new
  end

  # GET /evaluables/1/edit
  def edit
  end

  # POST /evaluables or /evaluables.json
  def create
    @evaluable = Evaluable.new(evaluable_params)

    respond_to do |format|
      if @evaluable.save
        format.html { redirect_to evaluable_url(@evaluable), notice: "Evaluable was successfully created." }
        format.json { render :show, status: :created, location: @evaluable }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @evaluable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluables/1 or /evaluables/1.json
  def update
    new_tags = if evaluable_params['tag']
                 if evaluable_params['tag'] == ','
                   []
                 elsif @evaluable.tags.include?(evaluable_params['tag'])
                  @evaluable.tags - [evaluable_params['tag']]
                 else
                   @evaluable.tags + [evaluable_params['tag']]
                 end
               else
                 @evaluable.tags
               end

    new_focus = if evaluable_params['focus']
                  if evaluable_params['focus'].to_i == @evaluable.focus
                    0
                  else
                    evaluable_params['focus'].to_i
                  end
                else
                  @evaluable.focus
                end

    @evaluable.update(tags: new_tags, focus: new_focus)
    render json: @evaluable
  end

  # DELETE /evaluables/1 or /evaluables/1.json
  def destroy
    @evaluable.destroy

    respond_to do |format|
      format.html { redirect_to evaluables_url, notice: "Evaluable was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_evaluable
    @evaluable = Evaluable.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def evaluable_params
    params.fetch(:evaluable, {}).permit(:tag, :focus)
  end
end
