Rails.application.routes.draw do

  get 'utils/erd', to: 'utils#erd'

  resources :scores
  post 'scores/quick_add', to: 'scores#quick_add'
  get  'scoresheet/:id', to: 'scores#scoresheet'

  resources :persons
  resources :users
  resources :sessionyears do
    resources :registrations
  end
  resources :registrations

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  # Sessions / login
  resources :sessions
  get  'calendar/:id', to: 'sessionyears#calendar'
  post 'calendar/:id', to: 'sessionyears#calendar'

  root :to => 'registrations#index'
end

