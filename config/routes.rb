Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#index"
  
  get "/about", to: "home#about"
  get "/data/question", to: "home#question", as: "data"
  get "/data/subject", to: "home#subject", as: "subject"

  get "/quiz(/:subject/:level/:journey)", to: "quiz#index", as: "quiz"
  get "/results/:id", to: "quiz#results", as: "results"

  post '/', to: 'home#new_journey'
  post "/quiz", to: "quiz#submit"
  post "/data/question", to: "home#submit_question"
  post "/data/subject", to: "home#submit_subject"

  # Defines the root path route ("/")
  # root "articles#index"
end
