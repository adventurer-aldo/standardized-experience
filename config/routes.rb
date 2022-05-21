Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'home#index'
  get '/class', to: 'home#lesson', as: 'lesson'
  get '/campaign', to: 'home#campaign', as: 'campaign'

  get '/about', to: 'home#about', as: 'about'
  get '/data/question', to: 'home#question', as: 'question'
  get '/data/subject', to: 'home#subject', as: 'subject'
  get '/data/statistics', to: 'home#statistics', as: 'statistics'
  get '/data/configurations', to: 'home#configurations', as: 'configurations'

  get '/quiz(/:subject/:level/:journey)', to: 'quiz#index', as: 'quiz'
  get '/results/:id', to: 'quiz#results', as: 'results'

  post '/', to: 'home#new_journey'
  post '/quiz', to: 'quiz#submit'
  post '/data/question', to: 'home#submit_question'
  post '/data/subject', to: 'home#submit_subject'

  # Defines the root path route ('/')
  # root 'articles#index'
end
