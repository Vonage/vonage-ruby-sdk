# typed: true

module Vonage
  class Messaging::Channels::Email < Messaging::Message
    MESSAGE_TYPES = ['text', 'html', 'content'].freeze

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

    def after_initialize!
      verify_type
      verify_message
      verify_opts
      build
    end

    def build
      data[:channel] = 'email'
      super
    end

    def verify_type
      raise Vonage::ClientError.new("Invalid message type") unless MESSAGE_TYPES.include?(type)
    end

    def verify_message
      case type
      when 'text'
        raise Vonage::ClientError.new("Invalid parameter type. `:message` must be a String") unless message.is_a? String
      when 'html'
        raise Vonage::ClientError.new("Invalid parameter type. `:message` must be a Hash") unless message.is_a? Hash
        raise Vonage::ClientError.new("Missing parameter. `:message` must contain a `:body` key") unless message[:body]
      when 'content'
        raise Vonage::ClientError.new("Invalid parameter type. `:message` must be an Array") unless message.is_a? Array
        raise Vonage::ClientError.new("Invalid parameter content. `:message` must not be empty") if message.empty?
        raise Vonage::ClientError.new("Invalid array contents. Each element of `:message` must be a Hash") unless message.all? { |m| m.is_a? Hash }
      else
        raise Vonage::ClientError.new("Invalid message type")
      end
    end

    def verify_opts
      raise Vonage::ClientError.new("Missing required parameter. `:opts` is required") if opts.nil? || opts.empty?
      raise Vonage::ClientError.new("Missing required parameter. `:email` is required in `:opts`") unless opts[:email]
      raise Vonage::ClientError.new("Missing required parameter. `:subject` is required in `:email`") unless opts[:email][:subject]
    end
  end
end
