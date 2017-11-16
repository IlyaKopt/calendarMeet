Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [ :index ]

  get '/redirect', to: 'calendars#redirect', as: 'redirect'
  get '/callback', to: 'calendars#callback', as: 'callback'
  get '/calendars', to: 'calendars#calendars', as: 'calendars'
  get '/events/:calendar_id', to: 'calendars#events', as: 'events', calendar_id: /[^\/]+/

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
