# typed: true

module Vonage
  class Messaging::Channels::SMS < Messaging::Message
    attr_reader :data

    def initialize(attributes = {})
      @type = attributes.fetch(:type, 'text')
      @message = attributes.fetch(:message, nil)
      @opts = attributes.fetch(:opts, {})
      @data = {}

      after_initialize!
    end

    private

    def build
      data[:channel] = 'sms'
      super
    end

    def verify_type
      raise Vonage::ClientError.new("Invalid message type") unless type == 'text'
    end

    def verify_message
      raise Vonage::ClientError.new(":message must be a String") unless message.is_a? String
    end
  end
end
