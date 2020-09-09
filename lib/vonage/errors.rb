# typed: strict
# frozen_string_literal: true
require 'json'

module Vonage
  module Errors
    extend T::Sig

    sig {params(response: T.any(Net::HTTPUnauthorized, Net::HTTPClientError, Net::HTTPServerError, T.untyped)).returns(Vonage::Error)}
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

      message = if response.content_type == 'application/json'
        hash = ::JSON.parse(response.body)

        if hash.key?('error_title')
          hash['error_title']
        elsif hash.key?('error-code-label')
          hash['error-code-label']
        elsif hash.key?('description')
          hash['description']
        elsif problem_details?(hash)
          problem_details_message(hash)
        end
      end

      exception_class.new(message)
    end

    sig { params(hash: T::Hash[String, T.untyped]).returns(T::Boolean) }
    def self.problem_details?(hash)
      hash.key?('title') && hash.key?('detail') && hash.key?('type')
    end

    sig { params(hash: T::Hash[String, T.untyped]).returns(String) }
    def self.problem_details_message(hash)
      "#{hash['title']}. #{hash['detail']} See #{hash['type']} for more info, or email support@nexmo.com if you have any questions."
    end
  end

  private_constant :Errors
end
