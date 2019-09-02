Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show] do
    resources :posts
  end
  
  resources :posts , only: [:show]

  root 'posts#index'
end
