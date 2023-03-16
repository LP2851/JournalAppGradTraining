Rails.application.routes.draw do
  root 'entries#index'
  resources :entries, only: [:create, :new, :destroy, :show, :edit, :update]
  resources :users, only: [:create, :new]

  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
end
