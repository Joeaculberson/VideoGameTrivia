Rails.application.routes.draw do
  resources :questions
  resources :games
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'users/registrations'}

  get '/promote' => 'users#promote'
  post '/promote' => 'users#update'

  get 'show_review' => 'questions#show_review'
  get 'accept_review' => 'questions#accept_review'
  get 'show_game' => 'games#show'
  get 'challenge' => 'questions#challenge'
  get 'steal_piece' => 'questions#steal_piece'
  get 'assess_answer' => 'games#assess_answer'


  post '/result' => 'questions#result'
  post '/chosen_category' => 'games#chosen_category'
  post 'steal_piece_settings' => 'games#steal_piece_settings'

  root 'games#index'
end