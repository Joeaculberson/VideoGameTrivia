Rails.application.routes.draw do
  resources :questions

  resources :games

  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}

  root 'games#index'

end
