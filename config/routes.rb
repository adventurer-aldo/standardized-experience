Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'home#index'
  get '/classes', to: 'home#lessons', as: 'lessons'
  get '/campanha', to: 'home#campaign', as: 'campaign'

  get '/sobre', to: 'home#about', as: 'about'
  get '/dados/questoes', to: 'home#question', as: 'question'
  get '/dados/disciplinas', to: 'home#subject', as: 'subject'
  get '/dados/estatisticas', to: 'home#statistics', as: 'statistics'
  get '/dados/configuracoes', to: 'home#configurations', as: 'configurations'

  get '/quiz(/:subject/:level/:journey)', to: 'quiz#index', as: 'quiz'
  get '/resulados/:id', to: 'quiz#results', as: 'results'

  post '/', to: 'home#new_journey'
  post '/quiz', to: 'quiz#submit'
  post '/dados/questoes', to: 'home#submit_question'
  post '/dados/disciplinas', to: 'home#submit_subject'

  # Defines the root path route ('/')
  # root 'articles#index'
end
