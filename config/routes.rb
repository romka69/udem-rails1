Rails.application.routes.draw do
  devise_for :users, controllers: {
                                              registrations: "users/registrations",
                                              omniauth_callbacks: "users/omniauth_callbacks"
                                            }

  root "home#index"

  get "home/index"
  get "activity", to: "home#activity"
  get "analytics", to: "home#analytics"
  get "privacy-policy", to: "home#privacy_policy"

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
      resources :comments, except: %i[index show update]
      put :sort
      delete :delete_video, on: :member
    end

    resources :enrollments, only: %i[new create]
    resources :course_creator, controller: "courses/course_creator"
  end

  resources :enrollments, except: %i[new create] do
    get :my_students, on: :collection
    get :certificate, on: :member
  end

  resources :users, only: %i[index show edit update]
  resources :youtube, only: :show
  resources :tags, only: %i[index create destroy]

  namespace :charts do
    get "users_per_day"
    get "enrollments_per_day"
    get "courses_popularity"
    get "money_makers"
  end
end
