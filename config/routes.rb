require 'sidekiq/web'

Wassup::Application.routes.draw do


  mount Sidekiq::Web, at: '/sidekiq'

end
