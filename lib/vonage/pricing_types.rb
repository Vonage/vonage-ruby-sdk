# typed: true
# frozen_string_literal: true

module Vonage
  class PricingTypes
    def initialize(config)
      @config = config
    end

    def sms
      @sms ||= Pricing.new(@config, type: 'sms')
    end

    def voice
      @voice ||= Pricing.new(@config, type: 'voice')
    end
  end
end
