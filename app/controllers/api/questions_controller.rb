class Api::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[ show edit update destroy ]

  # GET api/questions or api/questions.json
  def index
    query = current_user.stat.questions.where(
      "question LIKE ?
      AND EXISTS (SELECT 1 FROM unnest(answer) AS ans WHERE ans LIKE ?)
      AND#{params[:level] == '' ? ' NOT' : ''} level=?
      AND#{params[:question_types] == '' ? " NOT" : ''} ? = ANY(question_types)
      AND#{params[:subject_id] == '' ? ' NOT' : ''} subject_id=?",
      "%#{params[:question]}%",
      "%#{params[:answer]}%", params[:level] == '' ? 5000 : params[:level], params[:question_types],
      params[:subject_id] == '' ? 0 : params[:subject_id]
    ).order(id: params[:order])
    tags = query.map(&:tags).flatten.uniq
    @questions = query.each_slice(16).to_a
    subjects = if current_user.stat.questions_pref.zero?
                 current_user.stat.subjects
               else
                 current_user.stat.subjects.or(Subjects.where(visibility: 0))
               end.map { |subject| [subject.id, subject.title] }

    page = if params[:page].to_i && params[:page].to_i > @questions.size
             @questions.size - 1
           elsif params[:page]
             params[:page].to_i
           else
             0
           end

    @questions[page]&.map! do |question|
      { id: question.id, subject: question.subject_id, question_types: question.question_types, level: question.level,
        question: question.question, answer: question.answer, tags: question.tags, parameters: question.parameters,
        image: question.image.attached? ? url_for(question.image) : "nil" }
    end

    render json: { tags:, page:, results: query.size, pages: @questions.size, subjects:, questions: @questions[page].nil? ? [] : @questions[page] }
  end

  # GET api/questions/1 or api/questions/1.json
  def show
    render json: { id: @question.id, subject: @question.subject_id, question_types: @question.question_types,
                   level: @question.level, question: @question.question, answer: @question.answer, image: @question.image.attached? ? url_for(@question.image) : nil,
                   tags: @question.tags, parameters: @question.parameters, choices: @question.choices.where(veracity: 0).map(&:texts) }
  end

  # GET api/questions/new
  def new
    @question = Question.new
  end

  # GET api/questions/1/edit
  def edit; end

  # POST api/questions or api/questions.json
  def create
    last_question = Question.where(subject_id: question_params['subject_id']).last
    @question = Question.new(question: question_params['question'].strip, answer: question_params['answer'].map(&:rstrip), tags: question_params['tags'].nil? ? [] : question_params['tags'],
                             question_types: question_params['question_types'], level: question_params['level'], parameters: question_params['parameters'].nil? ? [] : question_params['parameters'],
                             subject_id: question_params['subject_id'], stat_id: current_user.stat.id)

    return unless @question.save

    Frequency.create(question_id: @question.id, stat_id: 1)

    if question_params['image'] || question_params['usePreviousImage'] == 'on'
      question_params['usePreviousImage'] == 'on' ? @question.image.attach(last_question.image.blob) : @question.image.attach(question_params['image'])
    end

    return unless question_params['choices']

    question_params['choices'].each { |_index, args| Choice.create(question_id: @question.id, texts: args['texts'].map(&:rstrip)) }

    return unless @question.question_types.intersect?(%w[choice veracity])

    question_params['answer'].each { |answer| Choice.create(question_id: @question.id, texts: [answer], veracity: 1) }
  end

  # PATCH/PUT api/questions/1 or api/questions/1.json
  def update
    return unless @question.stat_id == current_user.stat.id

    @question.update(question: question_params['question'], answer: question_params['answer'], tags: question_params['tags'].nil? ? [] : question_params['tags'],
                     question_types: question_params['question_types'], level: question_params['level'],
                     subject_id: question_params['subject_id'], parameters: question_params['parameters'].nil? ? [] : question_params['parameters'])
    Choice.destroy_by(question_id: @question.id)
    return unless @question.save && question_params['choices']

    question_params['choices'].each { |_index, args| Choice.create(question_id: @question.id, texts: args['texts']) }
    question_params['answer'].each { |answer| Choice.create(question_id: @question.id, texts: [answer], veracity: 1) }
  end

  # DELETE api/questions/1 or api/questions/1.json
  def destroy
    @question.destroy if @question.stat_id == current_user.stat.id
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.fetch(:question, {}).permit(:usePreviousImage, :subject_id, :image, :question, :level, :stat_id, question_types: [], choices: {}, answer: [], tags: [], parameters: [])
  end
end
