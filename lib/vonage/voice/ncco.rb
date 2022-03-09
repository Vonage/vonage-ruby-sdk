# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Ncco
    ACTIONS = {
      connect: Vonage::Voice::Actions::Connect,
      conversation: Vonage::Voice::Actions::Conversation,
      input: Vonage::Voice::Actions::Input,
      notify: Vonage::Voice::Actions::Notify,
      record: Vonage::Voice::Actions::Record,
      stream: Vonage::Voice::Actions::Stream,
      talk: Vonage::Voice::Actions::Talk
    }

    class << self
      ACTIONS.keys.each do |method|
        define_method method do |attributes|
          ACTIONS[method].new(**attributes).action
        end
      end
    end

    def self.method_missing(method)
      raise ClientError.new("NCCO action must be one of the valid options. Please refer to https://developer.nexmo.com/voice/voice-api/ncco-reference#ncco-actions for a complete list.")
    end

    # Create an NCCO
    #
    # @example
    #   talk = Vonage::Voice::Ncco.talk(text: 'This is sample text')
    #   input = Vonage::Voice::Ncco.input(type: ['dtmf'])
    #   ncco = Vonage::Voice::Ncco.create(talk, input)
    #
    # @option actions [Vonage::Voice::Ncco]
    #
    # @return [Array]
    #
    # @see https://developer.nexmo.com/voice/voice-api/ncco-reference
    def self.create(*actions)
      actions.flatten!
    end
  end
end
