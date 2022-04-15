class TransactionsController < ApplicationController
  def show
    txid = params[:txid]
    rawtransaction = Glueby::Internal::RPC.client.getrawtransaction(txid.to_s)
    @decodedtransaction = Glueby::Internal::RPC.client.decoderawtransaction(rawtransaction)
    @json = JSON.pretty_generate(@decodedtransaction)
  end
end
