Rails.application.routes.draw do
  namespace :api do
    resources :restaurants
  end
end
