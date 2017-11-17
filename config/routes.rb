Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [ :index ]

  get '/redirect', to: 'calendars#redirect', as: 'redirect'
  get '/callback', to: 'calendars#callback', as: 'callback'
  get '/events', to: 'calendars#events', as: 'events'

  root 'home#index'
end
