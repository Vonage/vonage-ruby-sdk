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
    def check(params, signature_method: @config.signature_method)
      params = params.dup

      signature = params.delete('sig')

      ::JWT::SecurityUtils.secure_compare(signature, digest(params, signature_method))
    end

    private

    def digest(params, signature_method)
      digest_string = params.sort.map { |k, v| "&#{k}=#{v.tr('&=', '_')}" }.join

      case signature_method
      when 'md5', 'sha1', 'sha256', 'sha512'
        OpenSSL::HMAC.hexdigest(signature_method, @config.signature_secret, digest_string).upcase
      when 'md5hash'
        Digest::MD5.hexdigest("#{digest_string}#{@config.signature_secret}")
      else
        raise ArgumentError, "Unknown signature algorithm: #{signature_method}. Expected: md5hash, md5, sha1, sha256, or sha512."
      end
    end
  end
end
