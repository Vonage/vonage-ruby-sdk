# typed: ignore
# frozen_string_literal: true

module Vonage
  class BearerToken < AbstractAuthentication
    def update(object)
      return unless object.is_a?(Net::HTTPRequest)

      object['Authorization'] = 'Bearer ' + @config.token
    end
  end

  private_constant :BearerToken
end
