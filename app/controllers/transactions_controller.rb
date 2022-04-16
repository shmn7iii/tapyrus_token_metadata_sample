class TransactionsController < ApplicationController
  def search
    txid = nil
    listunspents = Glueby::Wallet.load(ENV['WALLET_ID']).internal_wallet.list_unspent
    listunspents.each do |listunspent|
      txid = listunspent[:txid] if listunspent[:color_id] == params[:color_id]
    end

    if txid
      redirect_to transactions_show_path(txid: txid)
    else
      flash[:danger] = 'No match :('
      redirect_to root_path
    end
  end

  def show
    txid = params[:txid]
    rawtransaction = Glueby::Internal::RPC.client.getrawtransaction(txid.to_s)
    @decodedtransaction = Glueby::Internal::RPC.client.decoderawtransaction(rawtransaction)
    @json = JSON.pretty_generate(@decodedtransaction)
  end
end
