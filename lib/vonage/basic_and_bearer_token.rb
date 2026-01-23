# typed: true
# frozen_string_literal: true

module Vonage
  class BasicAndBearerToken < AbstractAuthentication
    def update(object, data)
      return unless object.is_a?(Net::HTTPRequest)

      if @config.authentication_preference == :basic
        object.basic_auth(@config.api_key, @config.api_secret)
      else
        object['Authorization'] = 'Bearer ' + @config.token
      end
    end
  end

  private_constant :BasicAndBearerToken
end
