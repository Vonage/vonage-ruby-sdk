# typed: true
# frozen_string_literal: true

module Vonage
  class NetworkAuthentication < AbstractAuthentication
    def update(object, data)
      return unless object.is_a?(Net::HTTPRequest)

      token = self.public_send(data[:auth_flow]).token(data).access_token

      object['Authorization'] = 'Bearer ' + token
    end

    def client
      @client ||= Client.new(@config)
    end

    def server
      @server ||= Server.new(@config)
    end
  end
end
