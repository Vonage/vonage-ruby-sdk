# typed: true
# frozen_string_literal: true

module Vonage
  class Messaging < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Send a Message.
    #
    # @example
    #   message = Vonage::Messaging::Message.sms(message: "Hello world!")
    #   response = client.messaging.send(to: "447700900000", from: "447700900001", **message)
    #
    # @option params [required, String] :to
    #
    # @option params [required, String] :from
    #
    # @option params [required, Hash] **message
    #   The Vonage Message object to use for this message.
    #
    # @see https://developer.vonage.com/api/messages-olympus#SendMessage
    #
    def send(params)
      request('/v1/messages', params: params, type: Post)
    end

    def verify_webhook_token(token:, signature_secret: @config.signature_secret)
      JWT.verify_hs256_signature(token: token, signature_secret: signature_secret)
    end
  end
end
