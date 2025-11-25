# typed: true
# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Wait
    attr_accessor :timeout, :eventUrl, :eventMethod

    def initialize(attributes = {})
      @timeout = attributes.fetch(:timeout, nil)

      after_initialize!
    end

    def after_initialize!
      validate_timeout if self.timeout
    end

    def validate_timeout
      timeout = self.timeout

      raise ClientError.new("Expected 'timeout' parameter to be a number") unless timeout.is_a?(Numeric)

      self.timeout
    end

    def action
      create_wait!(self)
    end

    def create_wait!(builder)
      ncco = [
        {
          action: 'wait'
        }
      ]

      ncco[0].merge!(timeout: builder.timeout) if builder.timeout

      ncco
    end
  end
end