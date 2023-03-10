# typed: true

module Vonage
  class Messaging::Channels::WhatsApp < Messaging::Message
    MESSAGE_TYPES = ['text', 'image', 'audio', 'video', 'file', 'template', 'sticker', 'custom']

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
      data[:channel] = 'whatsapp'
      super
    end

    def verify_type
      raise ClientError.new("Invalid message type") unless MESSAGE_TYPES.include?(type)
    end

    def verify_message
      case type
      when 'text'
        raise Vonage::ClientError.new(":message must be a String") unless message.is_a? String
      when 'template'
        raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new(":name is required in :template") unless message[:name]
        raise Vonage::ClientError.new(":whatsapp is required in :opts") unless opts[:whatsapp]
        raise Vonage::ClientError.new(":locale is required in :whatsapp") unless opts[:whatsapp][:locale]
      when 'sticker'
        raise Vonage::ClientError.new(":message must contain either :id or :url") unless message.has_key?(:id) ^ message.has_key?(:url)
      when 'custom'
        raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
      else
        raise Vonage::ClientError.new(":message must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new(":url is required in :message") unless message[:url]
      end
    end
  end
end
