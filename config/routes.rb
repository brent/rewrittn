Rewrittn::Application.routes.draw do
  resources :users do
    member do
      get :following, :followers, :snippets, :rewrites
    end
  end
  resources :sessions,      only: [:new, :create, :destroy]
  resources :snippets,      only: [:show, :new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :rewrites

  root "static_pages#home"

  post 'add_snippet', to: 'add_snippet#create'
  match 'bookmarklet', to: 'add_snippet#index', via: 'get'
  match "/signup",  to: "users#new",            via: 'get'
  match "/signin",  to: "sessions#new",         via: 'get'
  match "/signout", to: "sessions#destroy",     via: 'delete'
  match "/about",   to: "static_pages#about",   via: 'get'
  match "/contact", to: "static_pages#contact", via: 'get'
end
