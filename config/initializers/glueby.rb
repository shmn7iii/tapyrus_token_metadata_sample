Tapyrus.chain_params = :dev
Glueby.configure do |config|
  config.wallet_adapter = :activerecord
  config.rpc_config = { schema: 'http', host: '127.0.0.1', port: 12_381, user: 'rpcuser', password: 'rpcpassword' }
end
