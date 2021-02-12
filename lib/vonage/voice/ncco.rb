

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

    ACTIONS.keys.each do |method|      
      self.class.send :define_method, method do |attributes|
        ACTIONS[method].new(**attributes).action
      end
    end

    def self.method_missing(method)
      raise ClientError.new("NCCO action must be one of the valid options. Please refer to https://developer.nexmo.com/voice/voice-api/ncco-reference#ncco-actions for a complete list.")
    end

    def self.create(*actions)
      actions.flatten!
    end
  end
end