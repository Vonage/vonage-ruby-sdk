# typed: false
# frozen_string_literal: true
require 'logger'
require 'forwardable'

module Nexmo
  class Logger
    extend T::Sig

    sig { params(logger: T.nilable(T.any(::Logger, Nexmo::Logger))).void }
    def initialize(logger)
      @logger = logger || ::Logger.new(nil)
    end

    extend Forwardable

    ::Logger::Severity.constants.map(&:downcase).each do |name|
      def_delegator :@logger, name, name
    end

    sig { params(request: T.any(Net::HTTP::Post, Net::HTTP::Get, Net::HTTP::Delete, Net::HTTP::Put)).void }
    def log_request_info(request)
      @logger = T.let(@logger, T.nilable(T.any(::Logger, Nexmo::Logger)))

      T.must(@logger).info do
        format('Nexmo API request', {
          method: request.method,
          path: request.uri.path
        })
      end
    end

    sig { params(
      response: T.any(Net::HTTPOK, Net::HTTPNoContent, Net::HTTPBadRequest, Net::HTTPInternalServerError, Net::HTTPResponse),
      host: String
    ).void }
    def log_response_info(response, host)
      T.must(@logger).info do
        format('Nexmo API response', {
          host: host,
          status: response.code,
          type: response.content_type,
          length: response.content_length,
          trace_id: response['x-nexmo-trace-id']
        })
      end
    end

    private

    sig { params(message: String, hash: T::Hash[Symbol, T.untyped]).returns(String) }
    def format(message, hash)
      return message if hash.nil?

      fields = hash.map { |key, value| "#{key}=#{value}" if value }.compact
      fields.unshift(message)
      fields.join(' ')
    end
  end
end
