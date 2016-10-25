require 'securerandom'
require 'openssl'
require 'jwt'

module Nexmo
  module JWT
    def self.auth_header(payload, private_key)
      payload[:iat] = iat = Time.now.to_i
      payload[:exp] = iat + 60
      payload[:jti] = SecureRandom.uuid

      private_key = OpenSSL::PKey::RSA.new(private_key) unless private_key.respond_to?(:sign)

      token = ::JWT.encode(payload, private_key, 'RS256')

      "Bearer #{token}"
    end
  end
end
