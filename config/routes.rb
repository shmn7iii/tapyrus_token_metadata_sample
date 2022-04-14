Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/nfts/show',     to: 'nfts#show'
  get    '/nfts/new',      to: 'nfts#new'
  post   '/nfts/create',   to: 'nfts#create'
end
