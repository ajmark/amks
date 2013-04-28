Karate67272::Application.routes.draw do

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
  
  # Semi-static page routes
  match 'home' => 'home#index', :as => :home
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'search' => 'home#search', :as => :search

  # Set the root url
  root :to => 'home#index'
  
end

