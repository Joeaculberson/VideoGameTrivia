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
  get 'random_game' => 'games#random_game'
  get 'resign_game' => 'games#resign'

  get 'hide_picture' => 'users#hide_picture'
  get 'show_picture' => 'users#show_picture'
  get 'hide_email' => 'users#hide_email'
  get 'show_email' => 'users#show_email'
  get 'hide_location' => 'users#hide_location'
  get 'show_location' => 'users#show_location'

  get 'coin_store' => 'games#coin_store'

  get '/users/:id', :to => 'users#add_location', :as => :user
  post '/users/:id', :to => 'users#add_location'

  post '/result' => 'questions#result'
  post '/chosen_category' => 'games#chosen_category'
  post '/spun_category' => 'games#spun_category'
  post 'steal_piece_settings' => 'games#steal_piece_settings'
  post '/pay' => 'questions#pay'

  root 'games#index'
end