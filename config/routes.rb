Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home#index'

  namespace :api do
    resources :answers, as: 'api_answer'
    resources :journeys, as: 'api_journey'
    resources :lessons, as: 'api_lesson'
    resources :questions, as: 'api_question'
    resources :quizzes, as: 'api_quiz'
    resources :subjects, as: 'api_subject'
    resources :stats, as: 'api_stats'
  end

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    mailer: 'users/mailer',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }

  get '/challenges', to: 'home#challenges', as: 'challenges'
  get '/classroom', to: 'home#classroom', as: 'classroom'
  get '/about', to: 'about#index', as: 'about'
  get '/data/questions', to: 'home#question', as: 'question'
  get '/data/subjects', to: 'home#subject', as: 'subject'
  get '/data', to: 'home#statistics', as: 'statistics'
  get '/data/settings', to: 'home#configurations', as: 'configurations'

  get '/quiz(/:subject/:level/:journey)', to: 'quiz#index', as: 'quiz'
  get '/results/:id', to: 'quiz#results', as: 'results'
  get '/lesson/:id', to: 'lesson#index', as: 'lesson'

  post '/quiz', to: 'quiz#submit'

  # Defines the root path route ('/')
  # root 'articles#index'
end
