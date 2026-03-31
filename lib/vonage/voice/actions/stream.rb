# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Stream
    attr_accessor :streamUrl, :level, :bargeIn, :loop

    def initialize(attributes = {})
      @streamUrl = attributes.fetch(:streamUrl)
      @level = attributes.fetch(:level, nil)
      @bargeIn = attributes.fetch(:bargeIn, nil)
      @loop = attributes.fetch(:loop, nil)

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

      ncco
    end
  end
end