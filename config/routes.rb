Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get "home/index"
  get "activity", to: "home#activity"
  get "analytics", to: "home#analytics"

  resources :courses do
    collection do
      get :purchased
      get :pending_review
      get :created
      get :unapproved
    end
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :lessons, except: %i[index] do
      put :sort
      delete :delete_video, on: :member
    end
    resources :enrollments, only: %i[new create]
  end

  resources :users, only: %i[index show edit update]

  resources :enrollments, except: %i[new create] do
    get :my_students, on: :collection
  end

  namespace :charts do
    get "users_per_day"
    get "enrollments_per_day"
    get "courses_popularity"
    get "money_makers"
  end
end
