# typed: true
# frozen_string_literal: true
 
 module Vonage 
  class Voice::Actions::Conversation
    attr_accessor :name, :musicOnHoldUrl, :startOnEnter, :endOnExit, :record, :canSpeak, :canHear, :mute

    def initialize(attributes = {})
      @name = attributes.fetch(:name)
      @musicOnHoldUrl = attributes.fetch(:musicOnHoldUrl, nil)
      @startOnEnter = attributes.fetch(:startOnEnter, nil)
      @endOnExit = attributes.fetch(:endOnExit, nil)
      @record = attributes.fetch(:record, nil)
      @canSpeak = attributes.fetch(:canSpeak, nil)
      @canHear = attributes.fetch(:canHear, nil)
      @mute = attributes.fetch(:mute, nil)

      after_initialize!
    end

    def after_initialize!
      if self.musicOnHoldUrl
        verify_music_on_hold_url
      end

      if self.startOnEnter
        verify_start_on_enter
      end

      if self.endOnExit
        verify_end_on_exit
      end

      if self.record
        verify_record
      end

      if self.canSpeak
        verify_can_speak
      end

      if self.canHear
        verify_can_hear
      end

      if self.mute
        verify_mute
      end
    end

    def verify_music_on_hold_url
      uri = URI.parse(self.musicOnHoldUrl)

      raise ClientError.new("Invalid 'musicOnHoldUrl' value, must be a valid URL") unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)

      self.musicOnHoldUrl
    end

    def verify_start_on_enter
      raise ClientError.new("Expected 'startOnEnter' value to be a Boolean") unless self.startOnEnter == true || self.startOnEnter == false
    end

    def verify_end_on_exit
      raise ClientError.new("Expected 'endOnExit' value to be a Boolean") unless self.endOnExit == true || self.endOnExit == false
    end

    def verify_record
      raise ClientError.new("Expected 'record' value to be a Boolean") unless self.record == true || self.record == false
    end

    def verify_can_speak
      raise ClientError.new("Expected 'canSpeak' value to be an Array of leg UUIDs") unless self.canSpeak.is_a?(Array)
    end

    def verify_can_hear
      raise ClientError.new("Expected 'canHear' value to be an Array of leg UUIDs") unless self.canHear.is_a?(Array)
    end

    def verify_mute
      raise ClientError.new("Expected 'mute' value to be a Boolean") unless self.mute == true || self.mute == false
      raise ClientError.new("The 'mute' value is not supported if the 'canSpeak' option is defined") if self.canSpeak
    end

    def action
      create_conversation!(self)
    end

    def create_conversation!(builder)
      ncco = [
        {
          action: 'conversation',
          name: builder.name
        }
      ]

      ncco[0].merge!(musicOnHoldUrl: builder.musicOnHoldUrl) if (builder.musicOnHoldUrl || builder.musicOnHoldUrl == false)
      ncco[0].merge!(startOnEnter: builder.startOnEnter) if (builder.startOnEnter || builder.startOnEnter == false)
      ncco[0].merge!(endOnExit: builder.endOnExit) if (builder.endOnExit || builder.endOnExit == false)
      ncco[0].merge!(record: builder.record) if builder.record
      ncco[0].merge!(canSpeak: builder.canSpeak) if builder.canSpeak
      ncco[0].merge!(canHear: builder.canHear) if builder.canHear
      ncco[0].merge!(mute: builder.mute) if builder.mute

      ncco
    end
  end
end
