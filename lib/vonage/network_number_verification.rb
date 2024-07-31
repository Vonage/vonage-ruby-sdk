# typed: strict
# frozen_string_literal: true
require 'phonelib'

module Vonage
  class NetworkNumberVerification < Namespace
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
    sig { params(phone_number: String, auth_data: Hash, hashed: T::Boolean).returns(Vonage::Response) }
    def verify(phone_number:, auth_data:, hashed: false)
      raise ArgumentError.new("`phone_number` must be in E.164 format") unless Phonelib.parse(phone_number).valid? || hashed == true
      raise ArgumentError.new("`phone_number` must be prepended with a `+`") unless phone_number.start_with?('+') || hashed == true
      raise ArgumentError.new("`auth_data` must contain key `:oidc_auth_code`") unless auth_data.has_key?(:oidc_auth_code)
      raise ArgumentError.new("`auth_data[:oidc_auth_code]` must be a String") unless auth_data[:oidc_auth_code].is_a?(String)
      raise ArgumentError.new("`auth_data` must contain key `:redirect_uri`") unless auth_data.has_key?(:redirect_uri)
      raise ArgumentError.new("`auth_data[:redirect_uri]` must be a String") unless auth_data[:redirect_uri].is_a?(String)

      params = {phone_number: phone_number}
      params[:hashed_phone_number] = params.delete(:phone_number) if hashed == true

      request(
        '/camara/number-verification/v031/verify',
        params: camelcase(params),
        type: Post,
        auth_data: {
          oidc_auth_code: auth_data[:oidc_auth_code],
          redirect_uri: auth_data[:redirect_uri],
          auth_flow: :client_authentication
        }
      )
    end
  end
end