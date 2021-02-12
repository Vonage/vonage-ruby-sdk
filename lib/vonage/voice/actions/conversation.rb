 module Vonage 
  class Voice::Actions::Conversation
    attr_accessor :name, :musicOnHoldUrl, :startOnEnter, :endOnExit, :record, :canSpeak, :canHear, :mute

    def initialize(**attributes)
      @name = attributes.fetch(:name)
      @musicOnHoldUrl = attributes.fetch(:musicOnHoldUrl, nil)
      @startOnEnter = attributes.fetch(:startOnEnter, nil)
      @endOnExit = attributes.fetch(:endOnExit, nil)
      @record = attributes.fetch(:record, nil)
      @canSpeak = attributes.fetch(:canSpeak, nil)
      @canHear = attributes.fetch(:canHear, nil)
      @mute = attributes.fetch(:mute, nil)
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
