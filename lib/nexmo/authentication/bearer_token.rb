# frozen_string_literal: true

module Nexmo
  class BearerToken < AbstractAuthentication
    def update(object)
      return unless object.is_a?(Net::HTTPRequest)

      object['Authorization'] = @client.authorization
    end
  end
end
