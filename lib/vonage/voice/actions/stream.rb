# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Stream
    attr_accessor :streamUrl, :level, :bargeIn, :loop, :eventOnCompletion, :eventUrl, :eventMethod

    def initialize(attributes = {})
      @streamUrl = attributes.fetch(:streamUrl)
      @level = attributes.fetch(:level, nil)
      @bargeIn = attributes.fetch(:bargeIn, nil)
      @loop = attributes.fetch(:loop, nil)
      @eventOnCompletion = attributes.fetch(:eventOnCompletion, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)

      after_initialize!
    end

    def after_initialize!
      verify_stream_url

      if self.level
        verify_level
      end

      if self.bargeIn
        verify_barge_in
      end

      if self.loop
        verify_loop
      end

      if self.eventOnCompletion || self.eventOnCompletion == false
        verify_event_on_completion
      end

      if self.eventUrl
        verify_event_url
      end

      if self.eventMethod
        verify_event_method
      end
    end

    def verify_stream_url
      stream_url = self.streamUrl

      unless stream_url.is_a?(Array) && stream_url.length == 1 && stream_url[0].is_a?(String)
        raise ClientError.new("Expected 'streamUrl' parameter to be an Array containing a single string item")
      end

      uri = URI.parse(stream_url[0])

      raise ClientError.new("Invalid 'streamUrl' value, must be a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
    end

    def verify_level
      raise ClientError.new("Expected 'level' value to be a number between -1 and 1") unless self.level.between?(-1, 1)
    end

    def verify_barge_in
      raise ClientError.new("Expected 'bargeIn' value to be a Boolean") unless self.bargeIn == true || self.bargeIn == false
    end

    def verify_loop
      raise ClientError.new("Expected 'loop' value to be either 0 or a positive integer") unless self.loop >= 0
    end

    def verify_event_on_completion
      raise ClientError.new("Expected 'eventOnCompletion' value to be a Boolean") unless self.eventOnCompletion == true || self.eventOnCompletion == false
    end

    def verify_event_url
      unless self.eventUrl.is_a?(Array) && self.eventUrl.length == 1 && self.eventUrl[0].is_a?(String)
        raise ClientError.new("Expected 'eventUrl' parameter to be an Array containing a single string item")
      end

      uri = URI.parse(self.eventUrl[0])

      raise ClientError.new("Invalid 'eventUrl' value, array must contain a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

      self.eventUrl
    end

    def verify_event_method
      valid_methods = ['GET', 'POST']

      raise ClientError.new("Invalid 'eventMethod' value. must be either: 'GET' or 'POST'") unless valid_methods.include?(self.eventMethod.upcase)
    end

    def action
      create_stream!(self)
    end

    def create_stream!(builder)
      ncco = [
        {
          action: 'stream',
          streamUrl: builder.streamUrl
        }
      ]

      ncco[0].merge!(level: builder.level) if builder.level
      ncco[0].merge!(bargeIn: builder.bargeIn) if (builder.bargeIn || builder.bargeIn == false)
      ncco[0].merge!(loop: builder.loop) if builder.loop
      ncco[0].merge!(eventOnCompletion: builder.eventOnCompletion) if (builder.eventOnCompletion || builder.eventOnCompletion == false)
      ncco[0].merge!(eventUrl: builder.eventUrl) if builder.eventUrl
      ncco[0].merge!(eventMethod: builder.eventMethod) if builder.eventMethod

      ncco
    end
  end
end