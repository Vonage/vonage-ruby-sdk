# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Talk
    attr_accessor :text, :bargeIn, :loop, :level, :language, :style

    def initialize(**attributes)
      @text = attributes.fetch(:text)
      @bargeIn = attributes.fetch(:bargeIn, nil)
      @loop = attributes.fetch(:loop, nil)
      @level = attributes.fetch(:level, nil)
      @language = attributes.fetch(:language, nil)
      @style = attributes.fetch(:style, nil)
    end

    def action
      create_talk!(self)
    end

    def create_talk!(builder)
      ncco = [
        {
          action: 'talk',
          text: builder.text
        }
      ]

      ncco[0].merge!(bargeIn: builder.bargeIn) if (builder.bargeIn || builder.bargeIn == false)
      ncco[0].merge!(loop: builder.loop) if builder.loop
      ncco[0].merge!(level: builder.level) if builder.level
      ncco[0].merge!(language: builder.language) if builder.language
      ncco[0].merge!(style: builder.style) if builder.style

      ncco
    end
  end
end