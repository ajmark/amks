Karate67272::Application.routes.draw do

  get "users/index"

  get "users/show"

  get "users/new"

  get "users/edit"

  get "dojo_students/index"

  get "dojo_students/show"

  get "dojo_students/new"

  get "dojo_students/edit"

  get "dojos/index"

  get "dojos/show"

  get "dojos/new"

  get "dojos/edit"

  get "tournaments/index"

  get "tournaments/show"

  get "tournaments/new"

  get "tournaments/edit"

  # Generated routes
  resources :events
  resources :registrations
  resources :sections
  resources :students
  resources :tournaments
  resources :dojos
  resources :dojo_students
  resources :users
  resources :sessions

  # Authentication routes
  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  
  # Semi-static page routes
  match 'home' => 'home#index', :as => :home
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'search' => 'home#search', :as => :search

  # Set the root url
  root :to => 'home#index'
  
end

