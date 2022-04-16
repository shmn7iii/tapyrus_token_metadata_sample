class TransactionsController < ApplicationController
  def search
    txid = nil
    if params[:color_id].start_with?('c1', 'c2', 'c3')
      listunspents = Glueby::Wallet.load(ENV['WALLET_ID']).internal_wallet.list_unspent
      listunspents.each do |listunspent|
        txid = listunspent[:txid] if listunspent[:color_id] == params[:color_id]
      end
    else
      txid = params[:color_id]
    end

    redirect_to transactions_show_path(txid: txid)
  end

  def show
    txid = params[:txid]
    begin
      rawtransaction = Glueby::Internal::RPC.client.getrawtransaction(txid.to_s)
      @decodedtransaction = Glueby::Internal::RPC.client.decoderawtransaction(rawtransaction)
      @json = JSON.pretty_generate(@decodedtransaction)
    rescue
      flash[:danger] = 'No transactions found :('
      redirect_to root_path
    end
  end
end
