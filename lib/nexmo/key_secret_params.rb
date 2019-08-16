module Nexmo
  class KeySecretParams < AbstractAuthentication
    def update(object)
      return unless object.is_a?(Hash)

      object[:api_key] = @client.api_key
      object[:api_secret] = @client.api_secret
    end
  end

  private_constant :KeySecretParams
end
