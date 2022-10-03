# frozen_string_literal: false

# Handles the main page stuff
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user.journeys.empty?
      @journey = current_user.journeys.last
      @progress = ['', 'Primeiras avaliações', 'Segundas avaliações', 'Reposições',
                   'Realização de trabalhos', 'Exames normais', 'Exames de recorrência',
                   'Resultados da jornada'][@journey.level]

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
    unless current_user.stat.evaluables.empty?
      @pop_quiz = current_user.stat.evaluables.sample.subject&.questions&.order(Arel.sql('RANDOM()'))
    end

    quiz = current_user.quizzes.last
    @last_quiz = if quiz
                   format('Seu último teste foi de %s, com nota %s. ',
                          quiz.subject.title,
                          quiz.grade(text: true)) + Misc::Text.evaluate(quiz.grade)
                 else
                   'Você ainda não fez nenhum teste. Porquê não iniciar um agora?'
                 end
  end

  def classroom
    @subjects = current_user.evaluables.map do |evaluable|
      { id: evaluable.subject_id, title: evaluable.subject.title }
    end
    @lesson = current_user.lessons.last
  end

  def challenges
    @challenges = Challenge.where(date: Date.new(Time.now.year, Time.now.mon, Time.now.day))
  end

  def question; end

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
