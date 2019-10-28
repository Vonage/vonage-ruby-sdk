require 'digest'
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
    def check(signature_method, params)
      params = params.dup

      signature = params.delete('sig')

      ::JWT::SecurityUtils.secure_compare(signature, digest(signature_method, params))
    end

    private

    def digest(signature_method, params)
      case signature_method
      when 'md5'
        hash = Digest::MD5.new
      when 'sha1'
        hash = Digest::SHA1.new
      when 'sha256'
        hash = Digest::SHA256.new
      when 'sha512'
        hash = Digest::SHA512.new
      else
        raise "Unknown signature algorithm: #{signature_method}. Expected: md5hash, md5, sha1, sha256, or sha512."
      end

      params.sort.each do |k, v|
        hash.update("&#{k}=#{v}")
      end

      hash.update(@secret)

      hash.hexdigest
    end
  end
end
