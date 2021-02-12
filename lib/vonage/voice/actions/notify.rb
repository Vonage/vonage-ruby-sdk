# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Notify
    attr_accessor :payload, :eventUrl, :eventMethod

    def initialize(**attributes)
      @payload = attributes.fetch(:payload)
      @eventUrl = attributes.fetch(:eventUrl)
      @eventMethod = attributes.fetch(:eventMethod, nil)
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