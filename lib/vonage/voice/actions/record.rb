# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Record
    attr_accessor :format, :split, :channels, :endOnSilence, :endOnKey, :timeOut, :beepStart, :eventUrl, :eventMethod, :transcription

    def initialize(attributes = {})
      @format = attributes.fetch(:format, nil)
      @split = attributes.fetch(:split, nil)
      @channels = attributes.fetch(:channels, nil)
      @endOnSilence = attributes.fetch(:endOnSilence, nil)
      @endOnKey = attributes.fetch(:endOnKey, nil)
      @timeOut = attributes.fetch(:timeOut, nil)
      @beepStart = attributes.fetch(:beepStart, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)
      @transcription = attributes.fetch(:transcription, nil)

      after_initialize!
    end

    def after_initialize!
      if self.format
        validate_format
      end

      if self.split
        validate_split
      end

      if self.channels
        validate_channels
      end

      if self.endOnSilence
        validate_end_on_silence
      end

      if self.endOnKey
        validate_end_on_key
      end

      if self.timeOut
        validate_time_out
      end

      if self.beepStart
        validate_beep_start
      end

      if self.eventUrl
        validate_event_url
      end

      if self.eventMethod
        validate_event_method
      end

      if self.transcription
        validate_transcription
      end
    end

    def validate_format
      valid_formats = ['mp3', 'wav', 'ogg']

      raise ClientError.new("Invalid format, must be one of: 'mp3', 'wav', 'ogg'") unless valid_formats.include?(self.format)
    end

    def validate_split
      raise ClientError.new("Expected 'split' value to be 'conversation' if defined") unless self.split == 'conversation'
    end

    def validate_channels
      raise ClientError.new("The 'split' parameter must be defined to 'conversation' to also define 'channels'") unless self.split

      raise ClientError.new("Expected 'split' parameter to be equal to or less than 32") unless self.channels <= 32
    end

    def validate_end_on_silence
      raise ClientError.new("Expected 'endOnSilence' value to be between 3 and 10") unless self.endOnSilence <= 10 && self.endOnSilence >= 3
    end

    def validate_end_on_key
      raise ClientError.new("Expected 'endOnKey' value to be a one of the following: a single digit between 1-9, '*' or '#'") unless self.endOnKey.match(/^(\*|[1-9]|\#)$/)
    end

    def validate_time_out
      raise ClientError.new("Expected 'timeOut' value to be between 3 and 7200 seconds") unless self.timeOut <= 7200 && self.timeOut >= 3
    end

    def validate_beep_start
      raise ClientError.new("Expected 'beepStart' value to be a Boolean") unless self.beepStart == true || self.beepStart == false
    end

    def validate_event_url
      unless self.eventUrl.is_a?(Array) && self.eventUrl.length == 1 && self.eventUrl[0].is_a?(String)
        raise ClientError.new("Expected 'eventUrl' parameter to be an Array containing a single string item")
      end

      uri = URI.parse(self.eventUrl[0])

      raise ClientError.new("Invalid 'eventUrl' value, array must contain a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

      self.eventUrl
    end

    def validate_event_method
      valid_methods = ['GET', 'POST']

      raise ClientError.new("Invalid 'eventMethod' value. Must be either: 'GET' or 'POST'") unless valid_methods.include?(self.eventMethod.upcase)
    end

    def validate_transcription
      raise ClientError.new("Expected 'transcription' parameter to be a Hash") unless self.transcription.is_a?(Hash)

      if self.transcription[:language]
        raise ClientError.new("Invalid 'language' value, must be a String") unless self.transcription[:language].is_a?(String)
      end

      if self.transcription[:eventUrl]
        event_url = self.transcription[:eventUrl]

        unless event_url.is_a?(Array) && event_url.length == 1 && event_url[0].is_a?(String)
          raise ClientError.new("Expected 'eventUrl' parameter to be an Array containing a single string item")
        end

        uri = URI.parse(event_url[0])

        raise ClientError.new("Invalid 'eventUrl' value, array must contain a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
      end

      if self.transcription[:eventMethod]
        event_method = self.transcription[:eventMethod]
        raise ClientError.new("Invalid 'eventMethod' value, must be either: 'GET' or 'POST'") unless ['GET', 'POST'].include?(event_method.upcase)
      end

      if self.transcription[:sentimentAnalysis]
        sentiment_analysis = self.transcription[:sentimentAnalysis]
        raise ClientError.new("Invalid 'sentimentAnalysis' value, must be a Boolean") unless sentiment_analysis == true || sentiment_analysis == false
      end

      # if self.dtmf[:maxDigits]
      #   raise ClientError.new("Expected 'maxDigits' to not be more than 22") if self.dtmf[:maxDigits] > 22
      # end

      # if self.dtmf[:submitOnHash]
      #   raise ClientError.new("Invalid 'submitOnHash' value, must be a Boolean") unless self.dtmf[:submitOnHash] == true || self.dtmf[:submitOnHash] == false
      # end
    end

    def action
      create_record!(self)
    end

    def create_record!(builder)
      ncco = [
        {
          action: 'record'
        }
      ]

      ncco[0].merge!(format: builder.format) if builder.format
      ncco[0].merge!(split: builder.split) if builder.split
      ncco[0].merge!(channels: builder.channels) if builder.channels
      ncco[0].merge!(endOnSilence: builder.endOnSilence) if builder.endOnSilence
      ncco[0].merge!(endOnKey: builder.endOnKey) if builder.endOnKey
      ncco[0].merge!(timeOut: builder.timeOut) if builder.timeOut
      ncco[0].merge!(beepStart: builder.beepStart) if builder.beepStart
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod
      ncco[0].merge!(transcription: builder.transcription) if builder.transcription

      ncco
    end
  end
end