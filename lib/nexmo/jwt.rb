# frozen_string_literal: true
require 'securerandom'
require 'openssl'
require 'jwt'

module Nexmo
  module JWT
    # Generate an encoded JSON Web Token.
    #
    # By default the Nexmo Ruby SDK generates a short lived JWT per request.
    #
    # To generate a long lived JWT for multiple requests or to specify JWT claims
    # directly call {Nexmo::JWT.generate} to generate a token, and set the token
    # attribute on the client object.
    #
    # @example
    #   claims = {
    #     application_id: application_id,
    #     nbf: 1483315200,
    #     exp: 1514764800,
    #     iat: 1483228800
    #   }
    #
    #   private_key = File.read('path/to/private.key')
    #
    #   client.token = Nexmo::JWT.generate(claims, private_key)
    #
    # @param [Hash] payload
    # @param [String, OpenSSL::PKey::RSA] private_key
    #
    # @return [String]
    #
    def self.generate(payload, private_key)
      payload[:iat] = iat = Time.now.to_i unless payload.key?(:iat) || payload.key?('iat')
      payload[:exp] = iat + 60 unless payload.key?(:exp) || payload.key?('exp')
      payload[:jti] = SecureRandom.uuid unless payload.key?(:jti) || payload.key?('jti')

      private_key = OpenSSL::PKey::RSA.new(private_key) unless private_key.respond_to?(:sign)

      ::JWT.encode(payload, private_key, 'RS256')
    end
  end
end
