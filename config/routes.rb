Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      post '/users', to: 'users#create'
      post '/sessions', to: 'sessions#create'
      
      resources :users, only: [:show]
      
      resources :stories do
        resources :comments, only: [:create, :destroy, :index]
        
        member do
          post 'upload_photos'
          delete 'remove_photo/:photo_id', to: 'stories#remove_photo'
        end
        
        collection do
          get 'published'
          get 'by_date'
        end
      end
      
      resources :categories, only: [:index, :show] do
        get 'stories', on: :member
      end
      
      namespace :admin do
        resources :stories, only: [:index] do
          member do
            post 'restore'
          end
        end
      end
    end
  end
end