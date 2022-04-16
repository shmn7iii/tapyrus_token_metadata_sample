class NftsController < ApplicationController
  require 'ipfs-api'

  skip_before_action :verify_authenticity_token

  def new; end

  def create
    # write file
    upload_file = params[:upload_file]
    upload_dir = Rails.root.join('tmp', 'storage')
    upload_file_path = upload_dir + Time.now.to_i.to_s
    File.binwrite(upload_file_path, upload_file.read)

    # upload to ipfs
    ipfs = IPFS::Connection.new('http://ipfs:5001')
    ipfs.add File.new(upload_file_path) do |node|
      @cid = node.hash
    end

    # load wallet
    begin
      wallet = Glueby::Wallet.load(ENV['WALLET_ID'])
    rescue Glueby::Internal::Wallet::Errors::WalletNotFound
      flash.now[:danger] = 'Wallet not found. Are you run ./bin/rails ttms:init? Run it and restart server!'
      render 'new'
      return
    end

    # create token
    begin
      token = Glueby::Contract::Token.issue_nft_with_metadata(issuer: wallet, prefix: '', metadata: @cid)
    rescue Glueby::Contract::Errors::InsufficientFunds
      # deposit
      block = Glueby::Internal::RPC.client.generatetoaddress(1, wallet.internal_wallet.receive_address,
                                                             ENV['AUTHORITY_KEY'])
      Rails.application.load_tasks
      Rake::Task['glueby:block_syncer:start'].execute
      Rake::Task['glueby:block_syncer:start'].clear
      retry
    end

    flash[:success] = 'Success!'
    redirect_to transactions_show_path(txid: token[1].txid)
  end
end
