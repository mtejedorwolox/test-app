Rails.application.routes.draw do
  root to: 'application#index'
  post 'order_closed_trades', to: 'application#order_closed_trades'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
