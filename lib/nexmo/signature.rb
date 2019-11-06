require 'openssl'
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
    def check(params, signature_method: 'md5hash')
      params = params.dup

      signature = params.delete('sig')

      ::JWT::SecurityUtils.secure_compare(signature, digest(params, signature_method))
    end

    private

    def digest(params, signature_method)
      digest_string = ''
      params.sort.each do |k, v|
        v.gsub(/[&_]/, '')
        digest_string << "&#{k}=#{v}"
      end

      if ['md5', 'sha1', 'sha256', 'sha512'].include? signature_method
        digest = OpenSSL::HMAC.hexdigest(signature_method, @secret, digest_string).upcase
      elsif signature_method == 'md5hash'
        digest = Digest::MD5.hexdigest("#{digest_string}#{@secret}")
      else
        raise "Unknown signature algorithm: #{signature_method}. Expected: md5hash, md5, sha1, sha256, or sha512."
      end
    end
  end
end
