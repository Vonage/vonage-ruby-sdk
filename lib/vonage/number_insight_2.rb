# typed: strict
# frozen_string_literal: true

module Vonage
  class NumberInsight2 < Namespace
    extend T::Sig

    self.authentication = Basic

    self.request_body = JSON

    # Make fraud check requests with a phone number by looking up fraud score and/or by checking sim swap status.
    #
    # @example
    #   response = client.number_insight_2.fraud_check(type: 'phone', phone: '447900000000', insights: ['fraud_score'])
    #
    # @param [required, String] :type The type of number to check.
    #   Accepted value is “phone” when a phone number is provided.
    #
    # @param [required, String] :phone A single phone number that you need insight about in the E.164 format.
    #
    # @param [required, Array] :insights An array of strings indicating the fraud check insights required for the number.
    #   Must be least one of: `fraud_score`, `sim_swap`
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/number-insight.v2#fraud_check
    #
    sig { params(type: String, phone: String, insights: T::Array[String]).returns(Vonage::Response) }
    def fraud_check(type:, phone:, insights:)
      raise ArgumentError.new("`insights` must not be an empty") if insights.empty?

      request('/v2/ni', params: {type: type, phone: phone, insights: insights}, type: Post)
    end
  end
end
