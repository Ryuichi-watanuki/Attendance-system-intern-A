Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  get '/basic_info',      to: 'users#edit_basic_info'
  post'/basic_info_edit', to: 'users#basic_info_edit'
  
  post '/timein_creat', to: 'users#time_in'
  post '/timeout_creat', to: 'users#time_out'
  
  get '/attendance_edit', to: 'attendances#attendance_edit'
  get '/attendance_edit', to: 'users#show'
  
  post '/update_all', to: 'attendances#update_bunch'

  resources :users do
    member do
      get :following, :followers
    end
  end
  

  
  resource :attendances
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  
end