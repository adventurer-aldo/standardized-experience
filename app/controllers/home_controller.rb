class HomeController < ApplicationController
  def index
    puts Stat.last.journey.to_s
    @journey_check = Journey.where(id: Stat.last.current_journey).exists?
    if @journey_check
      @journey = Journey.find_by(id: Stat.first.current_journey)
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
                   format('Your last test was of %s, with a score of %s.', quiz.subject.title, helpers.grade(quiz))
                 else
                   "You haven't done any test yet. Practice or start a journey!"
                 end


  end

  def question
    @subjects = Subject.select(:title).order(title: 'asc')
  end

  def subject
    @subjects = Subject.all.order(title: :asc)
  end

  def submit_subject
    case params[:operation]
    when 'add'
      Subject.create(
        title: params[:title], 
        preferredformat: params[:preferredformat],
        difficulty: rand(1..5)
      )
    when 'delete'
      Question.destroy_by(subject: params[:id].to_i)
      Subject.destroy_by(id: params[:id].to_i)
    end
    redirect_to subject_path
  end

  def submit_question
    @old_question = Question.last
    @new_question = Question.create(
        question: params[:question],
        questiontype: params[:type],
        answer: params[:answer],
        subject: params[:subject],
        level: params[:level].to_i,
        parameters: params[:parameters]
                                  )

    case params[:reuse_image]
    when '0'
      @new_question.image.attach(params[:image]) unless params[:image].nil?
    when '1'
      @new_question.image.attach(@old_question.image.blob) unless @old_question.image.nil?
    end

    if !params[:choice].nil?
      params[:choice].uniq.each do |choice|
        Choice.create(decoy: choice, question: @new_question.id)
      end
      cookies[:choices] = params[:choice].size
    else
      cookies[:choices] = 0
    end

    cookies[:level] = params[:level]
    cookies[:type] = params[:type]
    cookies[:subject] = params[:subject]
    cookies[:reuse_image] = params[:reuse_image]

    redirect_to data_path
  end

  def about; end

  def new_journey
    subjects = Subject.where(evaluable: 1).order(title: :asc)
    journey = Journey.create(duration: 0, start_time: Time.now, soundtrack_id: Soundtrack.order(Arel.sql('RANDOM()')).limit(1).first.id)

    subjects.each do |subject|
      Chair.create(subject_id: subject.id, journey_id: journey.id, format: rand(0..1).round)
    end

    Stat.last.update(current_journey: journey.id)
  end

end