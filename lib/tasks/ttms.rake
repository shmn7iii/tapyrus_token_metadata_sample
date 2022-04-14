namespace :ttms do
  desc 'get init coin'
  task init: :environment do
    wallet = Glueby::Wallet.create
    address = wallet.internal_wallet.receive_address

    block = Glueby::Internal::RPC.client.generatetoaddress(1, address, ENV['AUTHORITY_KEY'])
    Rake.application['glueby:block_syncer:start'].execute

    puts ""
    puts "=== init ==="
    puts "wallet.id: #{wallet.id}"
    puts "address: #{address}"
    puts "wallet.balances: #{wallet.balances}"
  end
end
