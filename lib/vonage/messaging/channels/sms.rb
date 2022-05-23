# typed: true

module Vonage
  class Messaging::Channels::SMS
    attr_reader :data

    def initialize(attributes = {})
      @type = attributes.fetch(:type, 'text')
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
      data[:channel] = 'sms'
      data[:message_type] = type
      data[type.to_sym] = message
      data.merge!(opts)
    end

    def verify_type
      raise Vonage::ClientError.new("Invalid message type") unless type == 'text'
    end

    def verify_message
      raise Vonage::ClientError.new(":message must be a String") unless message.is_a? String
    end
  end
end
