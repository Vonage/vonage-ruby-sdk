module Vonage
  class ServerError < Error
    def initialize(message)
      super(message: message)
    end
  end
end
