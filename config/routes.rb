Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'welcome#index', as: 'root'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'
  get '/dashboard', to: 'users#show'

  # get '/users/:user_id/movies', to: 'movies#index'
  resources :discover, only: [:index]
  resources :movies, only: [:index, :show] do
    resources :viewing_party, only: [:new, :create]
  end
  resources :users, only: [:create]
end
