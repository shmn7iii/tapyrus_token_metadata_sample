Rails.application.routes.draw do
  root   'static_pages#home'

  post   '/transactions/search',  to: 'transactions#search'
  get    '/transactions/show',    to: 'transactions#show'

  get    '/nfts/new',      to: 'nfts#new'
  post   '/nfts/create',   to: 'nfts#create'
end
