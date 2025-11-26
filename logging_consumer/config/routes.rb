Rails.application.routes.draw do
  get 'log_events/index'
  get 'log_events/search'
  get 'search', to: 'log_events#search'

  root 'log_events#index'
end
