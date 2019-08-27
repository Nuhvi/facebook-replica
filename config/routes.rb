Rails.application.routes.draw do
  get 'users', to: 'users#index'
  get 'users/show', to: 'users#show'
  devise_for :users
  root 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
