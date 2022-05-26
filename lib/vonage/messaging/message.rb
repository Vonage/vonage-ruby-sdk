# typed: true

module Vonage
  class Messaging::Message
    CHANNELS = {
      sms: Vonage::Messaging::Channels::SMS,
      mms: Vonage::Messaging::Channels::MMS,
      whatsapp: Vonage::Messaging::Channels::WhatsApp,
      messenger: Vonage::Messaging::Channels::Messenger,
      viber: Vonage::Messaging::Channels::Viber
    }

    class << self
      CHANNELS.keys.each do |method|
        define_method method do |attributes|
          CHANNELS[method].new(**attributes).data
        end
      end
    end

    def self.method_missing(method)
      raise ClientError.new("Messaging channel must be one of the valid options.")
    end
  end
end
