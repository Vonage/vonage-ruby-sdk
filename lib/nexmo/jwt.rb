# frozen_string_literal: true
require 'securerandom'
require 'openssl'
require 'jwt'

module Nexmo
  module JWT
    def self.generate(payload, private_key)
      payload[:iat] = iat = Time.now.to_i unless payload.key?(:iat) || payload.key?('iat')
      payload[:exp] = iat + 60 unless payload.key?(:exp) || payload.key?('exp')
      payload[:jti] = SecureRandom.uuid unless payload.key?(:jti) || payload.key?('jti')

      private_key = OpenSSL::PKey::RSA.new(private_key) unless private_key.respond_to?(:sign)

      ::JWT.encode(payload, private_key, 'RS256')
    end
  end
end
