Rails.application.routes.draw do
  root 'posts#index' 
  devise_for :users
  resources  :users, only: [:show] do
    member do
      get :friends
    end
  end
  resources :relationships, only: [:create, :update, :destroy]
end
