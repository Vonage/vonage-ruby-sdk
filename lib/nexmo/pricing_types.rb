# frozen_string_literal: true

module Nexmo
  class PricingTypes
    def initialize(client)
      @client = client
    end

    def sms
      @sms ||= Pricing.new(@client, type: 'sms')
    end

    def voice
      @voice ||= Pricing.new(@client, type: 'voice')
    end
  end
end
