Rails.application.routes.draw do
  root 'posts#index'

  # Devise (login/logout) for HTML requests
  devise_for :users, defaults: { format: :html }, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

=begin   devise_scope :user do
    get '/users/sign_in', to: 'devise/sessions#new'
    get '/users/sign_up', to: 'users/registrations#new'
    post '/users', to: 'users/registrations#create'
    delete '/users/sign_out', to: 'devise/sessions#destroy'
    get '/users/confirmation/new', to: 'devise/confirmations#new'
    get '/users/confirmation', to: 'devise/confirmations#show'
    post '/users/confirmation', to: 'devise/confirmations#create'
  end
=end

  # API namespace, for JSON requests at /api/sign_[in|out]
  namespace :api do
    devise_for :users, defaults: { format: :json },
                       class_name: 'ApiUser',
                       skip: %i[omniauth_callbacks registrations
                                passwords confirmations
                                unlocks],
                       path: '',
                       path_names: { sign_in: 'login',
                                     sign_out: 'logout' }
    devise_scope :user do
      get 'login', to: 'devise/sessions#new'
      delete 'logout', to: 'devise/sessions#destroy'
    end
  end


  resources :users, only: %i[index show]
  resources :friendships, only: %i[index create update destroy]
  resources :posts, only: %i[index create] do
    resources :comments, only: %i[index create]
    resources :likes, only: %i[create destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
