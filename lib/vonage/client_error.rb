# typed: strong

module Vonage
  class ClientError < Error
    def initialize(message)
      super(message: message)
    end
  end
end
