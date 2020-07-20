# typed: false
# frozen_string_literal: true
require 'securerandom'
require 'openssl'
require 'nexmo-jwt'

module Nexmo
  class JWT
    # Generate an encoded JSON Web Token.
    #
    # By default the Nexmo Ruby SDK generates a short lived JWT per request.
    #
    # To generate a long lived JWT for multiple requests or to specify JWT claims
    # directly call {Nexmo::JWT.generate} to generate a token, and set the token
    # attribute on the client object.
    #
    # Documentation for the Nexmo Ruby JWT generator gem can be found at
    # https://www.rubydoc.info/github/nexmo/nexmo-jwt-ruby
    #
    # @example
    #   claims = {
    #     application_id: application_id,
    #     ttl: 800,
    #     subject: 'My_Subject'
    #   }
    #
    #   private_key = File.read('path/to/private.key')
    #
    #   client.config.token = Nexmo::JWT.generate(claims, private_key)
    #
    # @param [Hash] payload
    # @param [String, OpenSSL::PKey::RSA] private_key
    #
    # @return [String]
    #
    def self.generate(payload, private_key = nil)
      payload[:private_key] = private_key unless payload[:private_key]
      @token = Nexmo::JWTBuilder.new(payload).jwt.generate
    end
  end
end
