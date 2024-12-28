Rails.application.routes.draw do
  get '/health', to: proc { [200, {}, ['ok']] }

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

  resources :subscribers, only: [:create]

  get '/auth/google_oauth2/callback', to: 'omniauth#google_oauth2'
  get '/auth/failure', to: 'omniauth#failure'

  post '/auth/:provider', to: redirect('/auth/%{provider}')
  get '/auth/:provider', to: redirect('/auth/%{provider}')
end