# typed: true

module Vonage
  class BasicAndSignature < AbstractAuthentication
    def update(object, data)
      if @config.authentication_preference == :signature
        return unless object.is_a?(Hash)
        
        object['api_key'] = T.must(@config).api_key
        object['timestamp'] =Time.now.to_i.to_s
        signature = Signature.new(@config).generate(object)
        object[:sig] = signature
      else
        return unless object.is_a?(Net::HTTPRequest)

        object.basic_auth(@config.api_key, @config.api_secret)
      end
    end
  end

  private_constant :Basic
end
