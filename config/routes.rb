Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :index]
  
  resources :posts 

  root 'posts#index'
end
