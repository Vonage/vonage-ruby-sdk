# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Input
    attr_accessor :type, :dtmf, :speech, :eventUrl, :eventMethod

    def initialize(attributes = {})
      @type = attributes.fetch(:type)
      @dtmf = attributes.fetch(:dtmf, nil)
      @speech = attributes.fetch(:speech, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)

      after_initialize!
    end

    def after_initialize!
      validate_type

      if self.dtmf
        validate_dtmf
      end

      if self.speech
        validate_speech
      end

      if self.eventUrl
        validate_event_url
      end

      if self.eventMethod
        validate_event_method
      end
    end

    def validate_type
      valid_types = ['dtmf', 'speech']

      raise ClientError.new("Invalid 'type', must be an Array of at least one String") unless self.type.is_a?(Array)
      raise ClientError.new("Invalid 'type' value, must be 'dtmf', 'speech' or both 'dtmf' and 'speech'") if (valid_types & self.type).empty?
    end

    def validate_dtmf
      raise ClientError.new("Expected 'dtmf' to be included in 'type' parameter if 'dtmf' options specified") unless self.type.include?('dtmf')

      if self.dtmf[:timeOut]
        raise ClientError.new("Expected 'timeOut' to not be more than 10 seconds") if self.dtmf[:timeOut] > 10
      end

      if self.dtmf[:maxDigits]
        raise ClientError.new("Expected 'maxDigits' to not be more than 22") if self.dtmf[:maxDigits] > 22
      end

      if self.dtmf[:submitOnHash]
        raise ClientError.new("Invalid 'submitOnHash' value, must be a Boolean") unless self.dtmf[:submitOnHash] == true || self.dtmf[:submitOnHash] == false
      end
    end

    def validate_speech
      raise ClientError.new("Expected 'speech' to be included in 'type' parameter if 'speech' options specified") unless self.type.include?('speech')

      if self.speech[:uuid]
        raise ClientError.new("Invalid 'uuid' value, must be an Array containing a single call leg ID element") unless self.speech[:uuid].is_a?(Array)
      end

      if self.speech[:endOnSilence]
        raise ClientError.new("Expected 'endOnSilence' to not be more than 10 seconds") unless self.speech[:endOnSilence] <= 10 && self.speech[:endOnSilence] >= 0
      end

      if self.speech[:context]
        raise ClientError.new("Expected 'context' to be an Array of strings") unless self.speech[:context].is_a?(Array)
      end

      if self.speech[:startTimeout]
        raise ClientError.new("Expected 'startTimeout' to not be more than 10 seconds") unless self.speech[:startTimeout] <= 10 && self.speech[:startTimeout] >= 0
      end

      if self.speech[:maxDuration]
        raise ClientError.new("Expected 'maxDuration' to not be more than 60 seconds") unless self.speech[:maxDuration] <= 60 && self.speech[:maxDuration] >= 0
      end
    end

    def validate_event_url
      uri = URI.parse(self.eventUrl)

      raise ClientError.new("Invalid 'eventUrl' value, must be a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

      self.eventUrl
    end

    def validate_event_method
      valid_methods = ['GET', 'POST']

      raise ClientError.new("Invalid 'eventMethod' value. must be either: 'GET' or 'POST'") unless valid_methods.include?(self.eventMethod.upcase)
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