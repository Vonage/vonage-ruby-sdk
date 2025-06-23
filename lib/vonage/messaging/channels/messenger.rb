# typed: true

module Vonage
  class Messaging::Channels::Messenger < Messaging::Message
    MESSAGE_TYPES = ['text', 'image', 'audio', 'video', 'file']

    attr_reader :data

    def initialize(attributes = {})
      @to = attributes.fetch(:to, nil)
      @from = attributes.fetch(:from, nil)
      @type = attributes.fetch(:type, nil)
      @message = attributes.fetch(:message, nil)
      @opts = attributes.fetch(:opts, {})
      @data = {}

      after_initialize!
    end

    private

    def build
      data[:channel] = 'messenger'
      super
    end

    def verify_type
      raise Vonage::ClientError.new("Invalid message type") unless MESSAGE_TYPES.include?(type)
    end

    def verify_message
      case type
      when 'text'
        raise Vonage::ClientError.new(":message must be a String") unless message.is_a? String
      else
        raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new(":url is required in :message") unless message[:url]
      end
    end
  end
end
