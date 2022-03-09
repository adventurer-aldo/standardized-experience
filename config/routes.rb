Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#index"
  
  get "/about", to: "home#about"
  get "/data", to: "home#data"

  get "/quiz(/:subject/:level)", to: "quiz#index", as: "quiz"
  get "/results/:id", to: "quiz#results", as: "results"
  post "/quiz", to: "quiz#submit"
  post "/data", to: "home#submit_question", as: "data"

  # Defines the root path route ("/")
  # root "articles#index"
end
