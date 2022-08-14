class HomeController < ApplicationController
  def index
    stat = Stat.last
    @journey_check = stat.journey
    if @journey_check
      @journey = stat.journey
      sound = @journey.soundtrack
      @ost = case @journey.level
             when 0, 7
               sound.home
             when 1
               sound.preparations
             when 2, 3
               sound.preparations_second
              when 4
               sound.preparations_dissertation
             when 5, 6
               sound.preparations_exam
             end
    end

    @ost = Soundtrack.first.home if @ost.nil?
    @tip = if Subject.where(evaluable: 1).exists?
             Subject.where(evaluable: 1).order(Arel.sql('RANDOM()')).limit(1).first.questions
           else
             Subject.all.order(Arel.sql('RANDOM()')).limit(1).first.questions
           end.order(Arel.sql('RANDOM()')).limit(1)

    quiz = Quiz.last

    @last_quiz = if quiz
                   format('Seu último teste foi de %s, com nota %s. ', quiz.subject.title, helpers.grade(quiz).to_s.gsub('.',',')) + Misc::Text.evaluate(helpers.grade(quiz))
                 else
                   'Você ainda não fez nenhum teste. Comece um ou faça uma jornada!'
                 end
  end

  def lessons; end

  def lesson
    temp_question = Question.all.sample.tags.sample
    @questions = Question.where('tags @> ARRAY[?]::varchar[]', temp_question)
  end

  def campaign; end

  def question
    if params[:operation] == 'delete'
      Question.destroy_by(id: params[:id].to_i)
      redirect_to question_path
      return
    end
    @subjects = if Subject.where(evaluable: 1).exists?
                  Subject.where(evaluable: 1)
                else
                  Subject.all
                end.order(title: 'asc')
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
    redirect_to("#{subject_path}#disciplinas")
  end

  def submit_question
    types = %w[open choice multichoice veracity caption formula table match fill]
    parameters = %w[strict order shambles]
    last_question = Question.last
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
                       last_question
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
        next if choice['image'].nil? || choice['image'] == ''

        decoy.image.attach(choice['image'])
      end
      cookies[:choices] = params[:choices].keys.size
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

  def about
  end

  def cadeiras
    File.open('cadeiras.json', 'w+') do |file|
      str = '{'
      Subject.all.each do |subject|
        str << %(subjects[#{subject.id}] = "#{subject.title}";\n)
      end
      str << '}'
      file.write(str)
      send_file(file)
    end
  end

  def questoes
    File.open('questoes.json', 'w+') do |file|
      str = '{"questions": ['
      Question.all.order(id: :desc).limit(200).each do |question|
        str << %({"id": #{question.id}, "subject": #{question.subject_id}, "level": #{question.level},
        "types": #{question.question_types}, "question": "#{(question.question.length > 30) ? "#{question.question[0..30]}..." : question.question}",
        "answers": #{question.answer}, "tags": #{question.tags},
        "image": "url('#{question.image.attached? ? question.image.url : 'https://i.ibb.co/dmtKHb0/black.png'}')",
        "frequency": #{question.frequency}, "parameters": #{question.parameters}},)
      end
      str[-1] = ''
      str << ']}'
      file.write(str)
      send_file(file)
    end
  end

  def new_journey
    journey = Journey.create(duration: 0, start_time: Time.now, soundtrack_id: Soundtrack.order(Arel.sql('RANDOM()')).limit(1).first.id)
    Subject.where(evaluable: 1).order(title: :asc).each do |subject|
      chair = Chair.create(subject_id: subject.id, journey_id: journey.id, format: rand(0..1).round)
      chair.update(dissertation: rand(0.0..20.0).round(2)) unless subject.questions.where(level: 3).exists?
    end

    Stat.last.update(journey_id: journey.id)
    redirect_to root_path
  end
  
  def statistics
    @all = Question.all.size
    @stats = [0, 0, 0]
    Question.all.each do |question|
      @stats[0] += question.frequency[0]
      @stats[1] += question.frequency[1]
      @stats[2] += question.frequency[2]
    end
    @quizzes = Quiz.all.order(id: :desc).limit(10)
  end

  def configurations
    stat = Stat.last
    @skip_dissertation = stat.skip_dissertation == 1 ? ' checked' : ''
    @long_journey = stat.long_journey == 1 ? ' checked' : ''
    @lenient_answer = stat.lenient_answer == 1 ? ' checked' : ''
    @lenient_name = stat.lenient_name == 1 ? ' checked' : ''
    @avoid_negative = stat.avoid_negative == 1 ? ' checked' : ''
    @questions_pref = stat.questions_pref == 1 ? ' checked' : ''
    @theme = stat.theme_id
  end

  def configure
    Stat.last.update(
      focus_level: params[:level].to_i
    )
    redirect_to configurations_path
  end

end
