namespace :ttms do
  desc 'get init coin'
  task init: :environment do
    puts ""
    puts "=== init ==="

    wallet = Glueby::Wallet.create
    puts "create wallet: #{wallet.id}"

    address = wallet.internal_wallet.receive_address
    puts "address: #{address}"

    block = Glueby::Internal::RPC.client.generatetoaddress(1, address, ENV['AUTHORITY_KEY'])
    Rake.application['glueby:block_syncer:start'].execute
    puts "wallet.balances: #{wallet.balances}"
  end
end
