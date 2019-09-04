Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :index]
  resources :posts 
  resources :comments, only: [:create]
  root 'posts#index'
end
