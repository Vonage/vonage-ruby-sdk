# typed: true
# frozen_string_literal: true
module Vonage
  class Voice::Actions::Talk
    attr_accessor :text, :bargeIn, :loop, :level, :language, :style, :premium

    def initialize(attributes= {})
      @text = attributes.fetch(:text)
      @bargeIn = attributes.fetch(:bargeIn, nil)
      @loop = attributes.fetch(:loop, nil)
      @level = attributes.fetch(:level, nil)
      @language = attributes.fetch(:language, nil)
      @style = attributes.fetch(:style, nil)
      @premium = attributes.fetch(:premium, nil)

      after_initialize!
    end

    def after_initialize!
      if self.bargeIn || self.bargeIn == false
        verify_barge_in
      end

      if self.loop
        verify_loop
      end

      if self.level
        verify_level
      end

      if self.style
        verify_style
      end

      if self.premium || self.premium == false
        verify_premium
      end
    end

    def verify_barge_in
      raise ClientError.new("Expected 'bargeIn' value to be a Boolean") unless self.bargeIn == true || self.bargeIn == false
    end

    def verify_loop
      raise ClientError.new("Expected 'loop' value to be either 0 or a positive integer") unless self.loop >= 0
    end

    def verify_level
      raise ClientError.new("Expected 'level' value to be a number between -1 and 1") unless self.level.between?(-1, 1)
    end

    def verify_style
      raise ClientError.new("Expected 'style' value to be an Integer") unless self.style.is_a?(Integer)
    end

    def verify_premium
      raise ClientError.new("Expected 'premium' value to be a Boolean") unless self.premium == true || self.premium == false
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
      ncco[0].merge!(premium: builder.premium) if (builder.bargeIn || builder.bargeIn == false)

      ncco
    end
  end
end
