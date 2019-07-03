require 'digest/md5'
require 'jwt'

module Nexmo
  class Signature
    def self.check(params, secret)
      params = params.dup

      signature = params.delete('sig')

      ::JWT::SecurityUtils.secure_compare(signature, digest(params, secret))
    end

    def initialize(client)
      @client = client
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
    def check(params)
      self.class.check(params, @client.signature_secret)
    end

    def self.digest(params, secret)
      md5 = Digest::MD5.new

      params.sort.each do |k, v|
        md5.update("&#{k}=#{v}")
      end

      md5.update(secret)

      md5.hexdigest
    end

    private_class_method :digest
  end
end
