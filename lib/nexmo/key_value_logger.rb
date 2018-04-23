# frozen_string_literal: true

module Nexmo
  class KeyValueLogger
    def initialize(logger)
      @logger = logger
    end

    def debug(message, data = nil)
      @logger.debug(format(message, data)) if @logger
    end

    def info(message, data = nil)
      @logger.info(format(message, data)) if @logger
    end

    def warning(message, data = nil)
      @logger.warning(format(message, data)) if @logger
    end

    def error(message, data = nil)
      @logger.error(format(message, data)) if @logger
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
