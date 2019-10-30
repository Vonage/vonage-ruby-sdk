require 'openssl'
require 'jwt'

module Nexmo
  class Signature
    def initialize(secret)
      @secret = secret
    end

    # Check webhook request signature.
    #
    # @example
    #   client = Nexmo::Client.new(signature_secret: 'secret')
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
    def check(params, signature_method: 'md5hash')
      params = params.dup

      signature = params.delete('sig')

      ::JWT::SecurityUtils.secure_compare(signature, digest(params, signature_method))
    end

    private

    def digest(params, signature_method)
      case signature_method
      when 'md5hash', 'md5'
        digest = OpenSSL::Digest::MD5.new
      when 'sha1'
        digest = OpenSSL::Digest::SHA1.new
      when 'sha256'
        digest = OpenSSL::Digest::SHA256.new
      when 'sha512'
        digest = OpenSSL::Digest::SHA512.new
      else
        raise "Unknown signature algorithm: #{signature_method}. Expected: md5hash, md5, sha1, sha256, or sha512."
      end

      params.sort.each do |k, v|
        digest.update("&#{k}=#{v}")
      end

      digest.update(@secret)

      if signature_method == 'md5'
        digest = OpenSSL::HMAC.hexdigest(digest, @secret, params.to_s)
      else
        digest.hexdigest
      end
    end
  end
end
