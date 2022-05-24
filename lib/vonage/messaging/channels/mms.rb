# typed: true

module Vonage
  class Messaging::Channels::MMS
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

    attr_accessor :type, :message, :opts
    attr_writer :data

    def after_initialize!
      verify_type
      verify_message
      build
    end

    def build
      data[:channel] = 'mms'
      data[:message_type] = type
      data[type.to_sym] = message
      data.merge!(opts)
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
