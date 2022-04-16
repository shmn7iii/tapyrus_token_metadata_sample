Rails.application.routes.draw do
  root   'static_pages#home'

  get    '/transactions/show', to: 'transactions#show'

  get    '/nfts/new',      to: 'nfts#new'
  post   '/nfts/create',   to: 'nfts#create'
end
