# typed: true

module Vonage
  class Messaging::Channels::RCS < Messaging::Message
    MESSAGE_TYPES = ['text', 'image', 'video', 'file', 'card', 'carousel', 'custom']

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
      data[:channel] = 'rcs'
      super
    end

    def verify_type
      raise ClientError.new("Invalid message type") unless MESSAGE_TYPES.include?(type)
    end

    def verify_message
      case type
      when 'text'
        raise Vonage::ClientError.new("Invalid parameter type. `:message` must be a String") unless message.is_a? String
      when 'card', 'carousel', 'custom'
        raise Vonage::ClientError.new("Invalid parameter type. `:message` must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new("Invalid parameter content. `:message` must not be empty") if message.empty?
      else
        raise Vonage::ClientError.new("Invalid parameter type. `:message` must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new("Missing parameter. `:message` must contain a `:url` key") unless message[:url]
      end
    end
  end
end
