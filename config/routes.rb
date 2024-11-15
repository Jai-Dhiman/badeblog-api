Rails.application.routes.draw do
      resources :users, only: [:create, :show, :update]
      resources :sessions, only: [:create]
      
      resources :stories do
        collection do
          get :drafts
        end
        resources :comments, only: [:create, :index, :update, :destroy]
      end
      
      resources :categories, only: [:index, :show] do
        get 'stories', on: :member
      end

end