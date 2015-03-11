Rails.application.routes.draw do
  resources :questions
  resources :games
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  get '/promote' => 'users#promote'
  post '/promote' => 'users#update'

  get 'show_review' => 'questions#show_review'
  get 'accept_review' => 'questions#accept_review'
  get 'show_game' => 'games#show'

  post '/result' => 'questions#result'
  post '/chosen_category' => 'games#chosen_category'

  root 'games#index'
end
