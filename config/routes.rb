Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'posts#index'
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end

  resources :users, only: [:show, :index]
  resources :posts 
end
