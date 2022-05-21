class HomeController < ApplicationController
  def index
    @journey_check = Journey.where(id: Stat.last.current_journey).exists?
    if @journey_check
      @journey = Stat.last.journey
      sound = @journey.soundtrack
      @ost = case @journey.level
             when 0, 7
               sound.home
             when 1
               sound.preparations
             when 2, 3
               sound.preparations_second
             when 5, 6
               sound.preparations_exam
             end
    end

    @ost = Soundtrack.first.home if @ost.nil?
    @tip = Question.all.order(Arel.sql('RANDOM()')).limit(1)

    quiz = Quiz.last

    @last_quiz = if quiz
                   format('Seu último teste foi de %s, com nota %g. ', quiz.subject.title, helpers.grade(quiz)) + Misc::Text.evaluate(helpers.grade(quiz))
                 else
                   'Você ainda não fez nenhum teste. Comece um ou faça uma jornada!'
                 end


  end

  def lessons; end
  
  def campaign; end

  def question
    if params[:operation] == 'delete'
      Question.destroy_by(id: params[:id].to_i)
      redirect_to question_path
      return
    end
    @subjects = Subject.all.order(title: 'asc')
    @tags = []
    return unless Question.exists?

    Question.all.map(&:tags).each do |tagging|
      @tags += tagging
    end
    @tags.uniq!
  end

  def subject
    @subjects = Subject.all.order(title: :asc)
  end

  def submit_subject
    case params[:operation]
    when 'add'
      Subject.create(title: params[:title], formula: params[:formula].to_i, difficulty: rand(1..5))
    when 'evaluable'
      Subject.find_by(id: params[:id].to_i).update(evaluable: params[:evaluability].to_i)
    when 'edit'
      Subject.find_by(id: params[:id].to_i).update(title: params[:title], formula: params[:formula].to_i)
    when 'delete'
      Subject.destroy_by(id: params[:id].to_i)
    end
    redirect_to( subject_path + '#disciplinas')
  end

  def submit_question
    types = %w[open choice multichoice veracity caption formula table]
    parameters = %w[strict]
    puts params[:answers].class
    new_question = Question.create(question: params[:question],
                                   question_types: eval(params[:types]).map { |i| types[i] },
                                   answer: params[:answer],
                                   subject_id: params[:subject],
                                   level: params[:level].to_i,
                                   tags: eval(params[:tags]),
                                   parameters: eval(params[:parameters]).map { |i| parameters[i] }
                                  )

    if params[:reuse_image]
      old_question = if params[:reuse_id] == '0' || Question.where(id: params[:reuse_id].to_i).exists? == false
                       Question.last
                     else
                       Question.find_by(id: params[:reuse_id].to_i)
                     end
      new_question.image.attach(old_question.image.blob) unless old_question.image.nil?
      cookies[:reuse_image] = 'true'
    else
      new_question.image.attach(params[:image]) unless params[:image].nil?
      cookies[:reuse_image] = 'false'
    end

    if params[:choices]
      params[:choices].each do |_key, choice|
        decoy = Choice.create(decoy: choice['text'], question_id: new_question.id)
        decoy.image.attach(choice['image']) if choice['image']
      end
      cookies[:choices] = params[:choices].size
    else
      cookies[:choices] = 0
    end

    cookies[:level] = params[:level]
    cookies[:types] = params[:types]
    cookies[:parameters] = params[:parameters]
    cookies[:subject] = params[:subject]
    cookies[:tags] = params[:tags]

    redirect_to question_path
  end

  def about; end

  def new_journey
    journey = Journey.create(duration: 0, start_time: Time.now, soundtrack_id: Soundtrack.order(Arel.sql('RANDOM()')).limit(1).first.id)

    Subject.where(evaluable: 1).order(title: :asc).each do |subject|
      chair = Chair.create(subject_id: subject.id, journey_id: journey.id, format: rand(0..1).round)
      chair.update(dissertation: rand(0.0..20.0)) unless subject.questions.where(level: 3).exists?
    end

    Stat.last.update(current_journey: journey.id)
  end
  
  def statistics; end

  def configurations; end

end