Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :courses
  get "home/index"
end
