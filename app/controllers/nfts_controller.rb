class NftsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    txid = params[:txid]
    rawtransaction = Glueby::Internal::RPC.client.getrawtransaction(txid.to_s)
    decodedtransaction = Glueby::Internal::RPC.client.decoderawtransaction(rawtransaction)
    @json = JSON.pretty_generate(decodedtransaction)
  end

  def new; end

  def create
    metadata = params[:metadata]

    # load wallet
    wallet = Glueby::Wallet.load(ENV['WALLET_ID'])

    begin
      # create token
      token = Glueby::Contract::Token.issue_nft_with_metadata(wallet:, prefix: '', metadata:)
    rescue Glueby::Contract::Errors::InsufficientFunds
      # deposit
      block = Glueby::Internal::RPC.client.generatetoaddress(1, wallet.internal_wallet.receive_address,
                                                             ENV['AUTHORITY_KEY'])
      Rails.application.load_tasks
      Rake::Task['glueby:block_syncer:start'].execute
      Rake::Task['glueby:block_syncer:start'].clear
      retry
    end

    redirect_to ntfs_show_path(txid: token[1].txid)
  end
end
