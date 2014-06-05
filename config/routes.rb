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

  match "/signup",  to: "users#new",            via: 'get'
  match "/signin",  to: "sessions#new",         via: 'get'
  match "/signout", to: "sessions#destroy",     via: 'delete'
  match "/about",   to: "static_pages#about",   via: 'get'
  match "/contact", to: "static_pages#contact", via: 'get'

  match "/bookmarklet", to: "add_snippet_bookmarklet#index", via: 'get'
  match "/add_snippet", to: "add_snippet_bookmarklet#create", via: 'get'
  match "/bookmarklet/add_snippet.(:format)", to: "add_snippet_bookmarklet#bookmarklet", via: 'get'
end
