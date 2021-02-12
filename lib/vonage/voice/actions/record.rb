# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Record
    attr_accessor :format, :split, :channels, :endOnSilence, :endOnKey, :timeOut, :beepStart, :eventUrl, :eventMethod

    def initialize(**attributes)
      @format = attributes.fetch(:format, nil)
      @split = attributes.fetch(:split, nil)
      @channels = attributes.fetch(:channels, nil)
      @endOnSilence = attributes.fetch(:endOnSilence, nil)
      @endOnKey = attributes.fetch(:endOnKey, nil)
      @timeOut = attributes.fetch(:timeOut, nil)
      @beepStart = attributes.fetch(:beepStart, nil)
      @eventUrl = attributes.fetch(:eventUrl, nil)
      @eventMethod = attributes.fetch(:eventMethod, nil)
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

      ncco
    end
  end
end