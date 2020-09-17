Rails.application.routes.draw do
  resources :courses
  root "home#index"
  get "home/index"
end
