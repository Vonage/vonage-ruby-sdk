# typed: strict
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class NetworkSIMSwap < Namespace
    extend T::Sig
    include Keys

    self.authentication = NetworkAuthentication

    self.host = :vonage_host

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
    sig { params(phone_number: String, max_age: T.nilable(Integer)).returns(Vonage::Response) }
    def check(phone_number:, max_age: nil)
      raise ArgumentError.new("`phone_number` must be in E.164 format") unless Phonelib.parse(phone_number).valid?
      raise ArgumentError.new("`phone_number` must be prepended with a `+`") unless phone_number.start_with?('+')
      if max_age
        raise ArgumentError.new("`max_age` must between 1 and 2400") unless max_age.between?(1, 2400)
      end

      params = {phone_number: phone_number}
      params[:max_age] = max_age if max_age

      request(
        '/camara/sim-swap/v040/check',
        params: camelcase(params),
        type: Post,
        auth_data: {
          login_hint: phone_number,
          purpose: 'FraudPreventionAndDetection',
          api_scope: 'check-sim-swap',
          auth_flow: :server_authentication
        }
      )
    end

    sig { params(phone_number: String).returns(Vonage::Response) }
    def retrieve_date(phone_number:)
      raise ArgumentError.new("`phone_number` must be in E.164 format") unless Phonelib.parse(phone_number).valid?
      raise ArgumentError.new("`phone_number` must be prepended with a `+`") unless phone_number.start_with?('+')

      params = {phone_number: phone_number}

      request(
        '/camara/sim-swap/v040/retrieve-date',
        params: camelcase(params),
        type: Post,
        auth_data: {
          login_hint: phone_number,
          purpose: 'FraudPreventionAndDetection',
          api_scope: 'retrieve-sim-swap-date',
          auth_flow: :server_authentication
        }
      )
    end
  end
end