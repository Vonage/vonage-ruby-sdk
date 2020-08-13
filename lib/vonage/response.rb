# typed: true

module Vonage
  class Response
    def initialize(entity=nil, http_response=nil)
      @entity = entity

      @http_response = http_response
    end

    attr_reader :http_response

    def respond_to_missing?(name, include_private = false)
      return super if @entity.nil?

      @entity.respond_to?(name)
    end

    def method_missing(name, *args)
      return super if @entity.nil?

      @entity.public_send(name, *args)
    end
  end
end
