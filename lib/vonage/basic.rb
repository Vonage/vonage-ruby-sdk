# typed: ignore

module Vonage
  class Basic < AbstractAuthentication
    def update(object)
      return unless object.is_a?(Net::HTTPRequest)

      object.basic_auth(@config.api_key, @config.api_secret)
    end
  end

  private_constant :Basic
end
