Rails.application.routes.draw do
  get  '/ntfs/show',    'nfts/show'
  get  '/nfts/new',     'nfts/new'
  post '/nfts/create',  'nfts/create'
end
