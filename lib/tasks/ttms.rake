namespace :ttms do
  desc 'get init coin'
  task init: :environment do
    wallet = Glueby::Wallet.create
    puts "create wallet: #{wallet.id}"

    address = wallet.internal_wallet.receive_address
    puts "address: #{address}"

    file = File.open('.env', 'a')
    file.puts "WALLET_ID=#{wallet.id}"
    file.close
    puts '.env has updated'
  end
end
