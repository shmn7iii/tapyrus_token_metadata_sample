module GluebyTap
  module Contract
    module Token
      # issue NFT with metadata
      # @param [Glueby::Wallet] issuer issuer's wallet
      # @param [String] prefix prefix of content
      # @param [Srting] metadata metadata
      def issue_nft_with_metadata(issuer:, prefix:, metadata:)
        # raw content convert to hex
        data = metadata.unpack1('H*')
        # create tx
        tx = create_tx_for_nft_with_metadata(issuer: issuer, prefix:, data:)
        # broadcast tx
        tx = issuer.internal_wallet.broadcast(tx)
        # get token_id
        out_point = tx.inputs.first.out_point
        color_id = Tapyrus::Color::ColorIdentifier.nft(out_point)

        # return [Token, Tx]
        [new(color_id:), tx]
      end
    end

    module TxBuilder
      # create tx for NFT with metadata
      # @param [Glueby::Wallet] issuer issuer's wallet
      # @param [String] prefix prefix of content
      # @param [String] data hex of metadata
      def create_tx_for_nft_with_metadata(issuer:, prefix:, data:)
        tx = Tapyrus::Tx.new

        fee = Glueby::Contract::FixedFeeEstimator.new.fee(dummy_issue_tx_from_out_point)
        sum, outputs = issuer.internal_wallet.collect_uncolored_outputs(fee)
        fill_input(tx, outputs)

        # TxOut for NFT
        out_point = tx.inputs.first.out_point
        color_id = Tapyrus::Color::ColorIdentifier.nft(out_point)
        receiver_script = Tapyrus::Script.parse_from_addr(issuer.internal_wallet.receive_address)
        receiver_colored_script = receiver_script.add_color(color_id)
        tx.outputs << Tapyrus::TxOut.new(value: 1, script_pubkey: receiver_colored_script)

        # TxOut for metadata
        metadata_script = create_script_for_nft_with_metadata(prefix, data)
        tx.outputs << Tapyrus::TxOut.new(value: 0, script_pubkey: metadata_script)

        fill_change_tpc(tx, issuer, sum - fee)
        issuer.internal_wallet.sign_tx(tx)
      end

      # create payload
      # @param [String] prefix
      # @param [String] data
      def create_payload_for_nft_with_metadata(prefix, data)
        payload = +''
        payload << prefix
        payload << data
        payload
      end

      # create script
      # @param [String] prefix
      # @param [String] data
      def create_script_for_nft_with_metadata(prefix, data)
        script = Tapyrus::Script.new
        script << Tapyrus::Script::OP_RETURN
        script << create_payload_for_nft_with_metadata(prefix, data)
        script
      end
    end
  end
end

Glueby::Contract::Token.singleton_class.prepend(GluebyTap::Contract::Token)
Glueby::Contract::TxBuilder.prepend(GluebyTap::Contract::TxBuilder)
