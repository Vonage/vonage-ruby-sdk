# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Input
    attr_accessor :type, :dtmf, :speech, :eventUrl, :eventMethod

    def initialize(**attributes)
      @type = attributes.fetch(:type)
      @dtmf = attributes.fetch(:dtmf, nil)
      @speech = attributes.fetch(:speech, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)
    end

    def action
      create_input!(self)
    end

    def create_input!(builder)
      ncco = [
        {
          action: 'input',
          type: builder.type
        }
      ]

      ncco[0].merge!(dtmf: builder.dtmf) if builder.dtmf
      ncco[0].merge!(speech: builder.speech) if builder.speech
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod

      ncco
    end
  end
end