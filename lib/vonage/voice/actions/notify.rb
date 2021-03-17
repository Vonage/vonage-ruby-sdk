# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Notify
    attr_accessor :payload, :eventUrl, :eventMethod

    def initialize(attributes = {})
      @payload = attributes.fetch(:payload)
      @eventUrl = attributes.fetch(:eventUrl)
      @eventMethod = attributes.fetch(:eventMethod, nil)

      after_initialize!
    end

    def after_initialize!
      validate_event_url

      if self.eventMethod
        validate_event_method
      end
    end

    def validate_event_url
      uri = URI.parse(self.eventUrl[0])

      raise ClientError.new("Expected 'eventUrl' value to be an Array with a single string") unless self.eventUrl.is_a?(Array)
      raise ClientError.new("Invalid 'eventUrl' value, must be a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

      self.eventUrl
    end

    def validate_event_method
      valid_methods = ['GET', 'POST']

      raise ClientError.new("Invalid 'eventMethod' value. must be either: 'GET' or 'POST'") unless valid_methods.include?(self.eventMethod.upcase)
    end

    def action
      create_notify!(self)
    end

    def create_notify!(builder)
      ncco = [
        {
          action: 'notify',
          payload: builder.payload,
          eventUrl: builder.eventUrl
        }
      ]

      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod

      ncco
    end
  end
end