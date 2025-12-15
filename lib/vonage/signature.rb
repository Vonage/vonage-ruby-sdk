# typed: true
# frozen_string_literal: true
require 'openssl'
require 'digest/md5'
require 'jwt'

module Vonage
  class Signature
    def initialize(config)
      @config = config
    end

    # Generate a request signature.
    #
    # @example
    #   client = Vonage::Client.new
    #   client.config.signature_secret = 'secret'
    #   client.config.signature_method = 'sha512'
    #   params = {
    #     'to' => '447900000000',
    #     'from' => '447900000001',
    #     'text' => 'Hello World',
    #     'timestamp' => '1385047698'
    #   }
    #
    #   sig = client.signature.generate(params)
    #
    # @param [Hash] params
    #
    # @see https://developer.nexmo.com/concepts/guides/signing-messages
    def generate(params, signature_secret: @config.signature_secret, signature_method: @config.signature_method)
      digest(params, signature_secret, signature_method)
    end
    
    # Check webhook request signature.
    #
    # @example
    #   client = Vonage::Client.new
    #   client.config.signature_secret = 'secret'
    #   client.config.signature_method = 'sha512'
    #
    #   if client.signature.check(request.GET)
    #     # valid signature
    #   else
    #     # invalid signature
    #   end
    #
    # @param [Hash] params
    #
    # @see https://developer.nexmo.com/concepts/guides/signing-messages
    #
    def check(params, signature_secret: @config.signature_secret, signature_method: @config.signature_method)
      params = params.dup

      signature = params.delete('sig')

      ::JWT::JWA::Hmac::SecurityUtils.secure_compare(signature, digest(params, signature_secret, signature_method))
    end

    private

    def digest(params, signature_secret, signature_method)
      digest_string = params.sort.map { |k, v| "&#{k}=#{v.tr('&=', '_')}" }.join

      case signature_method
      when 'md5', 'sha1', 'sha256', 'sha512'
        OpenSSL::HMAC.hexdigest(signature_method, signature_secret, digest_string).upcase
      when 'md5hash'
        Digest::MD5.hexdigest("#{digest_string}#{signature_secret}")
      else
        raise ArgumentError, "Unknown signature algorithm: #{signature_method}. Expected: md5hash, md5, sha1, sha256, or sha512."
      end
    end
  end
end
