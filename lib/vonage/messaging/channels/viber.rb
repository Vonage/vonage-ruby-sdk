# typed: true

module Vonage
  class Messaging::Channels::Viber  < Messaging::Message
    MESSAGE_TYPES = ['text', 'image', 'video', 'file']

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
      data[:channel] = 'viber_service'
      super
    end

    def verify_type
      raise Vonage::ClientError.new("Invalid message type") unless MESSAGE_TYPES.include?(type)
    end

    def verify_message
      case type
      when 'text'
        raise Vonage::ClientError.new(":message must be a String") unless message.is_a? String
      when 'image'
        raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new(":url is required in :message") unless message[:url]
      when 'video'
        raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new(":url is required in :message") unless message[:url]
        raise Vonage::ClientError.new(":thumb_url is required in :message") unless message[:thumb_url]
      when 'file'
        raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new(":url is required in :message") unless message[:url]
      end
    end
  end
end
