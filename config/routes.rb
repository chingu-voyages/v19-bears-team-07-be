Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #!! Sets up devise routes
  devise_for :users, path: 'auth'


  get 'test_login/index'
  get 'test_login/is_logged_in', to: 'test_login#is_signed_in'


  # Done as part of setup for Devise auth
  root to: "test_login#index"

  # CRUD for Apps, Users, Tags, Catgories
  resources :skills, except: [:new, :edit]
  resources :users, except: [:new, :edit]

  resources :apps, except: [:new, :edit] do 
    resources :comments, except: [:new, :edit]
    resources :tags, except: [:new, :edit]
  end

  resources :categories, except: [:new, :edit] do 
    member do 
      get "apps"
    end
  end

  resources :ratings, only: [:index]


  # CRUD for resources owned by the authenticated user
  namespace :me do 
    resources :apps, except: [:new, :edit]
    resources :rated_apps, only: [:index, :update, :destroy]
    resources :favorite_apps, only: [:index, :update, :destroy]
  end

  get 'users/:id/portfolio', to: 'users#portfolio'
  get 'users/:id/skills', to: 'users#skills'

  # Route for search
  get 'search', to: 'searches#index'
end
