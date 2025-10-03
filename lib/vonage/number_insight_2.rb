# typed: strict
# frozen_string_literal: true

module Vonage
  class NumberInsight2 < Namespace
    extend T::Sig

    self.authentication = Basic

    self.request_body = JSON

   # @deprecated
    sig { params(type: String, phone: String, insights: T::Array[String]).returns(Vonage::Response) }
    def fraud_check(type:, phone:, insights:)
      logger.info('This method is deprecated and will be removed in a future release.')
      raise ArgumentError.new("`insights` must not be an empty") if insights.empty?

      request('/v2/ni', params: {type: type, phone: phone, insights: insights}, type: Post)
    end
  end
end
