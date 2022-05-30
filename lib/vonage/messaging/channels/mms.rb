# typed: true

module Vonage
  class Messaging::Channels::MMS < Messaging::Message
    MESSAGE_TYPES = ['image', 'vcard', 'audio', 'video']

    attr_reader :data

    def initialize(attributes = {})
      @type = attributes.fetch(:type, nil)
      @message = attributes.fetch(:message, nil)
      @opts = attributes.fetch(:opts, {})
      @data = {}

      after_initialize!
    end

    private

    def build
      data[:channel] = 'mms'
      super
    end

    def verify_type
      raise Vonage::ClientError.new("Invalid message type") unless MESSAGE_TYPES.include?(type)
    end

    def verify_message
      raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
      raise Vonage::ClientError.new(":url is required in :message") unless message[:url]
    end
  end
end
