class NftsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    txid =params[:txid]
    rawtransaction = Glueby::Internal::RPC.client.getrawtransaction(txid.to_s)
    decodedtransaction = Glueby::Internal::RPC.client.decoderawtransaction(rawtransaction)
    @json = JSON.pretty_generate(decodedtransaction)
  end

  def new
  end

  def create
    metadata =  params[:metadata]

    # create wallet and deposit it
    wallet = Glueby::Wallet.create
    address = wallet.internal_wallet.receive_address

    # create block
    block = Glueby::Internal::RPC.client.generatetoaddress(1, address, ENV['AUTHORITY_KEY'])
    Rails.application.load_tasks
    Rake::Task['glueby:block_syncer:start'].execute
    Rake::Task['glueby:block_syncer:start'].clear

    # create token
    token = Glueby::Contract::Token.issue_nft_with_metadata(wallet: wallet, prefix: '', metadata: metadata)

    redirect_to ntfs_show_path(txid: token[1].txid)
  end

end
