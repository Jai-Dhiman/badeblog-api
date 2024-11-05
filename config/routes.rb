Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: [:create, :show]
      resources :sessions, only: [:create]
      
      resources :stories do
        resources :comments, only: [:create, :index]
      end
      
      resources :categories, only: [:index, :show] do
        get 'stories', on: :member
      end
    end
  end
end