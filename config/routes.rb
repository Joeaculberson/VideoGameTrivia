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

  get 'sound_on' => 'users#sound_on'
  get 'sound_off' => 'users#sound_off'
  get 'hide_picture' => 'users#hide_picture'
  get 'show_picture' => 'users#show_picture'
  get 'hide_email' => 'users#hide_email'
  get 'show_email' => 'users#show_email'
  get 'hide_location' => 'users#hide_location'
  get 'show_location' => 'users#show_location'
  get 'hide_store' => 'users#hide_store'
  get 'show_store' => 'users#show_store'

  get 'coin_store' => 'games#coin_store'

  get 'express_checkout' => 'orders#express_checkout'
  get 'new_order' => 'orders#new'
  get 'orders' => 'orders#show'

  get 'leaderboard' => 'games#leaderboard'
  get 'process_wrong_answer' => 'games#process_wrong_answer'
  get 'end_attacker_steal_turn' => 'games#end_attacker_steal_turn'

  get '/users/:id', :to => 'users#update_profile', :as => :user
  post '/users/:id', :to => 'users#update_profile'

  post '/result' => 'questions#result'
  post '/chosen_category' => 'games#chosen_category'
  post '/spun_category' => 'games#spun_category'
  post 'steal_piece_settings' => 'games#steal_piece_settings'
  post '/pay' => 'questions#pay'

  root 'games#index'
end