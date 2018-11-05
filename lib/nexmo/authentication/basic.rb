module Nexmo
  class Basic < AbstractAuthentication # :nodoc:
    def update(object)
      return unless object.is_a?(Net::HTTPRequest)

      object.basic_auth(@client.api_key, @client.api_secret)
    end
  end
end
