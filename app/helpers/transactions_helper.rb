module TransactionsHelper
  def decode_metadata(str_metadata)
    [str_metadata].pack('H*')
  end
end
