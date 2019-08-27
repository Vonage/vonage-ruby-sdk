module Nexmo
  class KeySecretParams < AbstractAuthentication
    def update(object)
      return unless object.is_a?(Hash)

      object[:api_key] = @config.api_key
      object[:api_secret] = @config.api_secret
    end
  end

  private_constant :KeySecretParams
end
