# frozen_string_literal: true

module Vonage
  class ResponseError < Error
    attr_reader :response

    def initialize(message, response:)
      @response = response
      super(message)
    end
  end
end
