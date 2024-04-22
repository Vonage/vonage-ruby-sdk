# typed: true
# frozen_string_literal: true
require 'forwardable'

module Vonage
  class Messaging < Namespace
    extend Forwardable

    self.authentication = BearerToken

    self.request_body = JSON

    def_delegators Message, *Message::CHANNELS.keys

    # Send a Message.
    #
    # @example
    #   message = client.messaging.sms(message: "Hello world!")
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
    def send(to:, from:, **message)
      request('/v1/messages', params: {to: to, from: from, **message}, type: Post)
    end

    # Validate a JSON Web Token from a Messages API Webhook.
    #
    # @param [String, required] :token The JWT from the Webhook's Authorization header
    # @param [String, optional] :signature_secret The account signature secret. Required, unless `signature_secret`
    #   is set in `Config`
    #
    # @return [Boolean] true, if the JWT is verified, false otherwise
    def verify_webhook_token(token:, signature_secret: @config.signature_secret)
      JWT.verify_hs256_signature(token: token, signature_secret: signature_secret)
    end
  end
end
