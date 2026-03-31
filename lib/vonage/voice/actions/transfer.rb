# typed: true
# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Actions::Transfer
    attr_accessor :conversation_id, :can_hear, :can_speak, :mute

    def initialize(attributes = {})
      @conversation_id = attributes.fetch(:conversation_id)
      @can_hear = attributes.fetch(:can_hear, nil)
      @can_speak = attributes.fetch(:can_speak, nil)
      @mute = attributes.fetch(:mute, nil)

      after_initialize!
    end

    def after_initialize!
      validate_conversation_id
      validate_can_hear if self.can_hear
      validate_can_speak if self.can_speak
      validate_mute if self.mute != nil
    end

    def validate_conversation_id
      conversation_id = self.conversation_id

      raise ClientError.new("Expected 'conversation_id' parameter to be a string") unless conversation_id.is_a?(String)

      self.conversation_id
    end

    def validate_can_hear
      can_hear = self.can_hear
      unless can_hear.is_a?(Array) && can_hear.all? { |item| item.is_a?(String) }
        raise ClientError.new("Expected 'can_hear' parameter to be an array of strings")
      end

      self.can_hear
    end

    def validate_can_speak
      can_speak = self.can_speak
      unless can_speak.is_a?(Array) && can_speak.all? { |item| item.is_a?(String) }
        raise ClientError.new("Expected 'can_speak' parameter to be an array of strings")
      end

      self.can_speak
    end

    def validate_mute
      mute = self.mute
      unless [true, false].include?(mute)
        raise ClientError.new("Expected 'mute' parameter to be a boolean")
      end

      if self.mute && self.can_speak
        raise ClientError.new("The 'mute' parameter is not supported if 'can_speak' is also set")
      end

      self.mute
    end

    def action
      create_transfer!(self)
    end

    def create_transfer!(builder)
      ncco = [
        {
          action: 'transfer',
          conversation_id: builder.conversation_id,
        }
      ]

      ncco[0].merge!(canHear: builder.can_hear) if builder.can_hear
      ncco[0].merge!(canSpeak: builder.can_speak) if builder.can_speak
      ncco[0].merge!(mute: builder.mute) if builder.mute != nil

      ncco
    end
  end
end