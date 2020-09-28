Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :courses
  resources :users, only: %i[index]
  get "home/index"
  get "home/activity"
end
