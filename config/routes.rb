Rails.application.routes.draw do
  root 'entries#index'
  resources :entries, only: [:create, :new, :destroy, :show, :edit, :update]
end
