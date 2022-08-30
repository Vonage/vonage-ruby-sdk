# typed: true
# frozen_string_literal: true
module Vonage
  class Voice::Actions::Pay
    attr_accessor :amount, :currency, :eventUrl, :prompts, :voice

    def initialize(attributes= {})
      @amount = attributes.fetch(:amount)
      @currency = attributes.fetch(:currency, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @prompts = attributes.fetch(:prompts, nil)
      @voice = attributes.fetch(:voice, nil)

      after_initialize!
    end

    def action
      create_pay!(self)
    end

    def create_pay!(builder)
      ncco = [
        {
          action: 'pay',
          amount: builder.amount
        }
      ]

      ncco[0].merge!(currency: builder.currency) if builder.currency
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(prompts: builder.prompts) if builder.prompts
      ncco[0].merge!(voice: builder.voice) if builder.voice

      ncco
    end

    private

    def after_initialize!
      verify_amount

      if self.eventUrl
        verify_event_url
      end

      if self.prompts
        verify_prompts
      end

      if self.voice
        verify_voice
      end
    end

    def verify_amount
      verify_amount_class
      verify_amount_value
    end

    def verify_event_url
      raise ClientError.new("Expected 'eventUrl' parameter to be an Array containing a single string item") unless self.eventUrl.is_a?(Array)

      uri = URI.parse(self.eventUrl[0])

      raise ClientError.new("Invalid 'eventUrl' value, must be a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
    end

    def verify_prompts
      verify_prompts_structure
      verify_prompts_values
    end

    def verify_voice
      verify_voice_structure
      verify_voice_style if self.voice[:style]
    end

    def verify_amount_class
      raise ClientError.new("Invalid 'amount' value, must be a float") unless self.amount.is_a?(Float)
    end

    def verify_amount_value
      raise ClientError.new("Invalid 'amount' value, must be greater than 0") unless self.amount > 0
    end

    def verify_prompts_structure
      raise ClientError.new("Invalid 'prompt', must be an array of at least one hash") unless self.prompts.is_a?(Array) && !self.prompts.empty? && self.prompts.all?(Hash)
    end

    def verify_prompts_values
      self.prompts.each do |prompt|
        prompt_keys = prompt.keys
        [:type, :text, :errors].each do |key|
          raise ClientError.new("Invalid 'prompt', '#{key}' is required") unless prompt_keys.include?(key)
        end
      end
    end

    def verify_voice_structure
      raise ClientError.new("Expected 'voice' value to be a Hash") unless self.voice.is_a?(Hash)
    end

    def verify_voice_style
      raise ClientError.new("Expected 'style' value to be an Integer") unless self.voice[:style].is_a?(Integer)
    end
  end
end
