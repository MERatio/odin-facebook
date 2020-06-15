Rails.application.routes.draw do
  root 'posts#index' 
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks', 
  }
  resources  :users, only: [:index, :show] do
    member do
      get :friends
    end
  end
  resources :relationships, only: [:create, :update, :destroy]
  resources :posts,         only: [:create, :show] do
    resources :reactions,   only: [:index, :create, :destroy]
    resources :comments,    only: [:create]
  end
end
