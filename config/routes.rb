Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :courses do
    resources :lessons
  end
  resources :users, only: %i[index show edit update]
  get "home/index"
  get "home/activity"
end
