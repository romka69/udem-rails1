Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get "home/index"
  get "activity", to: "home#activity"
  get "analytics", to: "home#analytics"
  get "charts/users_per_day", to: "charts#users_per_day"
  get "charts/enrollments_per_day", to: "charts#enrollments_per_day"
  get "charts/course_popularity", to: "charts#course_popularity"

  resources :courses do
    get :purchased, on: :collection
    get :pending_review, on: :collection
    get :created, on: :collection
    resources :lessons, except: %i[index]
    resources :enrollments, only: %i[new create]
  end

  resources :users, only: %i[index show edit update]

  resources :enrollments, except: %i[new create] do
    get :my_students, on: :collection
  end
end
