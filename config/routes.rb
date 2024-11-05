Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      post '/users', to: 'users#create'
      post '/sessions', to: 'sessions#create'
      
      resources :users, only: [:show, :update] do
        get 'profile', on: :collection
        member do
          patch 'preferences'
        end
      end
      
      resources :stories do
        resources :comments, only: [:create, :update, :destroy, :index]
        
        member do
          post 'upload_photos'
          delete 'remove_photo/:photo_id', to: 'stories#remove_photo'
          post 'preview'
          post 'autosave'
          post 'reorder_photos'
          patch 'photo_caption'
        end
        
        collection do
          get 'drafts'
          get 'published'
          get 'recent'
          get 'by_date'
          get 'search'
        end
      end
      
      resources :categories, only: [:index, :show] do
        get 'stories', on: :member
      end
    end
  end
end