# typed: strict
# frozen_string_literal: true

module Vonage
  class Redact < Namespace
    extend T::Sig

    self.authentication = Basic

    self.request_body = JSON

    # Redact a specific message.
    #
    # @example
    #   response = client.redact.transaction(id: '00A0B0C0', product: 'sms')
    #
    # @option params [required, String] :id
    #   The transaction ID to redact.
    #
    # @option params [required, String] :product
    #   Product name that the ID provided relates to.
    #
    # @option params [required, String] :type
    #   Required if redacting SMS data.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/redact#redact-message
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def transaction(params)
      request('/v1/redact/transaction', params: params, type: Post)
    end
  end
end
