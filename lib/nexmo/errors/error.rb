# frozen_string_literal: true
require 'json'

module Nexmo
  class Error < StandardError
    # @api private
    def self.parse(response)
      exception_class = case response
        when Net::HTTPUnauthorized
          AuthenticationError
        when Net::HTTPClientError
          ClientError
        when Net::HTTPServerError
          ServerError
        else
          Error
        end

      message = if content_type = response['Content-Type']
        case content_type.split(';').first
        when 'application/problem+json'
          Problem.parse(response.body)
        when 'application/json'
          hash = ::JSON.parse(response.body)
          hash['error_title']
        end
      end

      exception_class.new(message)
    end
  end
end
