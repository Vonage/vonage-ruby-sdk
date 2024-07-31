# typed: true
# frozen_string_literal: true

module Vonage
  class NetworkAuthentication < AbstractAuthentication
    def update(object, data)
      return unless object.is_a?(Net::HTTPRequest)

      token = self.public_send(data[:auth_flow]).token(**data)

      object['Authorization'] = 'Bearer ' + token
    end

    def client_authentication
      @client_authentication ||= ClientAuthentication.new(@config)
    end

    def server_authentication
      @server_authentication ||= ServerAuthentication.new(@config)
    end
  end
end
