# frozen_string_literal: true
require 'logger'
require 'forwardable'

module Nexmo
  class Logger # :nodoc:
    def initialize(logger)
      @logger = logger || ::Logger.new(nil)
    end

    extend Forwardable

    ::Logger::Severity.constants.map(&:downcase).each do |name|
      def_delegator :@logger, name, name
    end

    def log_request_info(request)
      info do
        format('Nexmo API request', {
          method: request.method,
          path: request.uri.path
        })
      end
    end

    def log_response_info(response, host)
      info do
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

    def format(message, hash)
      return message if hash.nil?

      fields = hash.map { |key, value| "#{key}=#{value}" if value }.compact
      fields.unshift(message)
      fields.join(' ')
    end
  end
end
