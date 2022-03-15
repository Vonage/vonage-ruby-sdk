# typed: strong

module Vonage
  class ServiceError < Error
    extend T::Sig

    sig { returns(Vonage::Response) }
    attr_reader :response

    sig { params(message: T.nilable(String), response: Vonage::Response).void }
    def initialize(message = nil, response:)
      super(message)
      @response = response
    end
  end
end
