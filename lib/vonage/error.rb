module Vonage
  class Error < StandardError
    attr_reader :status

    def initialize(message: nil, status: nil)
      super(message)
      @status = status&.to_i
    end
  end
end
