Rails.application.routes.draw do
  resources :lessons
  devise_for :users
  root "home#index"
  resources :courses
  resources :users, only: %i[index show edit update]
  get "home/index"
  get "home/activity"
end
