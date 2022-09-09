class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user.stat.journeys.empty?
      @journey = current_user.stat.journeys.last
      @progress = case @journey.level
                  when 1
                    'Primeiras avaliações'
                  when 2
                    'Segundas avaliações'
                  when 3
                    'Reposições'
                  when 4
                    'Realização de Trabalhos'
                  when 5
                    'Exames Normais'
                  when 6
                    'Exames de Recorrência'
                  when 7
                    'Resultados da Jornada'
                  end
      @ost = "quiz/#{@journey.soundtrack.name}/"
      @ost += case @journey.level
              when 0, 7
                @journey.soundtrack.home
              when 1
                @journey.soundtrack.preparations
              when 2, 3
                @journey.soundtrack.preparations_second
              when 4
                @journey.soundtrack.preparations_dissertation
              when 5, 6
                @journey.soundtrack.preparations_exam
              end

      @start_time = @journey.start_time.to_time.to_f * 1000
      @chairs = @journey.chairs.size
    end

    @ost = Soundtrack.first.home if @ost.nil?
    @pop_quiz = Subject.find_by(id: current_user.stat.evaluables.sample).questions.order(Arel.sql('RANDOM()')).limit(1)

    quiz = current_user.stat.quizzes.last
    @last_quiz = if quiz
                   format('Seu último teste foi de %s, com nota %s. ',
                          quiz.subject.title,
                          helpers.grade(quiz, true)) + Misc::Text.evaluate(helpers.grade(quiz))
                 else
                   'Você ainda não fez nenhum teste. Comece um!'
                 end
  end

  def lessons; end

  def lesson
    temp_question = Question.all.sample.tags.sample
    @questions = Question.where('tags @> ARRAY[?]::varchar[]', temp_question)
  end

  def campaign; end

  def question
    @auth_token = form_authenticity_token
  end

  def subject
    @auth_token = form_authenticity_token
    @formulas = Array(0..4).map { |a| helpers.formula(a) }
  end

  def about; end

  def statistics
    @all = Question.all.size
    @stats = [0, 0, 0]
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
end
