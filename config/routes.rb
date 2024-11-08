Rails.application.routes.draw do
  #     resources :users, only: [:create, :show, :update]
  #     resources :sessions, only: [:create]
      
  #     resources :stories do
  #       resources :comments, only: [:create, :index]
  #     end
      
  #     resources :categories, only: [:index, :show] do
  #       get 'stories', on: :member
  #     end
  get "/stories/:id" => "stories#show"



end