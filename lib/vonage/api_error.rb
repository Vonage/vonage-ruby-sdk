# typed: strong
require "json"

module Vonage
  class APIError < Error
    extend T::Sig

    sig { returns(Net::HTTPResponse) }
    attr_reader :http_response

    sig { params(message: T.nilable(String), http_response: T.nilable(Net::HTTPResponse)).void }
    def initialize(message = nil, http_response: nil)
      super(message)
      @http_response = http_response
    end

    def http_response_code
      return nil unless http_response
      http_response.code
    end

    def http_response_headers
      return nil unless http_response
      http_response.to_hash
    end

    def http_response_body
      return nil unless http_response
      return {} unless http_response.content_type && http_response.content_type.include?("json")
      ::JSON.parse(http_response.body)
    end
  end
end
