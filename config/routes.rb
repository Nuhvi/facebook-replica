Rails.application.routes.draw do
  get 'friendships/index'
  devise_for :users

  authenticated :user do
    root 'posts#index'
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end

  resources :users, only: [:show, :index] do
    get 'friends', to: 'friendships#index'
    post 'friend', to: 'friendships#create'
    post 'accept', to: 'friendships#update'
    delete 'unfriend', to: 'friendships#destroy'
  end
  
  resources :posts 
  resources :comments
  resources :likes, only: [:index, :create, :destroy]
end
