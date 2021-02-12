# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Stream
    attr_accessor :streamUrl, :level, :bargeIn, :loop

    def initialize(**attributes)
      @streamUrl = attributes.fetch(:streamUrl)
      @level = attributes.fetch(:level, nil)
      @bargeIn = attributes.fetch(:bargeIn, nil)
      @loop = attributes.fetch(:loop, nil)
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