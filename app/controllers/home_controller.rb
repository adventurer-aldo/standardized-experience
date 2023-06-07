# frozen_string_literal: false

# Handles the main page stuff
class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user.journeys.empty?
      @journey = current_user.journeys.last

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
      @cheer = Misc::Text.cheer[@journey.level].sample
    end

    @ost = "quiz/#{Soundtrack.first.name}/#{Soundtrack.first.home}.ogg" if @ost.nil?

    unless current_user.stat.evaluables.empty?
      random_study_question = current_user.stat.evaluables.sample.subject&.questions&.order(Arel.sql('RANDOM()'))
      random_study_question = random_study_question&.first
      unless random_study_question.nil?
        type = random_study_question.question_types.sample
        @pop_quiz = { choices: helpers.map_with_decoys(random_study_question.generate_variables(type)),
                      id: random_study_question.id, question_type: type, question: random_study_question.question }
      end
    end

    quiz = current_user.quizzes.where.not(last_grade: nil).last
    @last_quiz = if quiz
                   format('Your last test was of %<subject_name>s, with the grade %<grade>s. %<text_cheer>s',
                          { subject_name: quiz.subject.title, grade: quiz.last_grade.to_s.gsub('.', ','),
                            text_cheer: Misc::Text.evaluate(quiz.last_grade) })
                 else
                   'You have not done a test yet. Why not start one?'
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
    stat = current_user.stat
    @skip_dissertation = stat.skip_dissertation == 1 ? ' checked' : ''
    @long_journey = stat.long_journey == 1 ? ' checked' : ''
    @lenient_answer = stat.lenient_answer == 1 ? ' checked' : ''
    @lenient_name = stat.lenient_name == 1 ? ' checked' : ''
    @avoid_negative = stat.avoid_negative == 1 ? ' checked' : ''
    @questions_pref = stat.questions_pref == 1 ? ' checked' : ''
    @theme = stat.theme_id
  end
end
