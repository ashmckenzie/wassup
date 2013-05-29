require 'sidekiq/web'

Wassup::Application.routes.draw do

  get "dashboard/index"

  root 'dashboard#index'

  mount Sidekiq::Web, at: '/sidekiq'
end
