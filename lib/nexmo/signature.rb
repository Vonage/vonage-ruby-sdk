require 'digest/md5'
require 'jwt'

module Nexmo
  class Signature
    def self.check(params, secret)
      params = params.dup

      signature = params.delete('sig')

      secure_compare(signature, digest(params, secret))
    end

    def initialize(client)
      @client = client
    end

    def check(params)
      self.class.check(params, @client.signature_secret)
    end

    private

    if defined?(::JWT::SecurityUtils) # ruby-jwt v2
      def self.secure_compare(left, right)
        ::JWT::SecurityUtils.secure_compare(left, right)
      end
    else
      def self.secure_compare(left, right)
        ::JWT.secure_compare(left, right)
      end
    end

    def self.digest(params, secret)
      md5 = Digest::MD5.new

      params.sort.each do |k, v|
        md5.update("&#{k}=#{v}")
      end

      md5.update(secret)

      md5.hexdigest
    end
  end
end
