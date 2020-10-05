Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :courses do
    resources :lessons, except: %i[index]
    resources :enrollments, only: %i[new create]
  end
  resources :users, only: %i[index show edit update]
  resources :enrollments, except: %i[new create]
  get "home/index"
  get "activity", to: "home#activity"
end
