Rails.application.routes.draw do
  resources :questions
  resources :games
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  get '/promote' => 'users#promote'
  post '/promote' => 'users#update'
  root 'games#index'
end
