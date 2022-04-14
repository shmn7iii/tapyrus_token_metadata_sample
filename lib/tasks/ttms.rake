namespace :ttms do
  desc 'get init coin'
  task init: :environment do
    wallet = Glueby::Wallet.create
    address = wallet.internal_wallet.receive_address

    count = 1
    authority_key = "cUJN5RVzYWFoeY8rUztd47jzXCu1p57Ay8V7pqCzsBD3PEXN7Dd4"
    block = Glueby::Internal::RPC.client.generatetoaddress(count, address, authority_key)

    Rake.application['glueby:block_syncer:start'].execute

    puts ""
    puts "=== init ==="
    puts "wallet.id: #{wallet.id}"
    puts "address: #{address}"
    puts "wallet.balances: #{wallet.balances}"
  end
end
