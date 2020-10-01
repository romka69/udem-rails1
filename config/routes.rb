Rails.application.routes.draw do
  resources :enrollments
  devise_for :users
  root "home#index"
  resources :courses do
    resources :lessons, except: %i[index]
  end
  resources :users, only: %i[index show edit update]
  get "home/index"
  get "home/activity"
end
