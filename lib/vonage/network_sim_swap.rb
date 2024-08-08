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

    # Check if SIM swap has been performed during a past period.
    #
    # @example
    #   response = client.network_sim_swap.check(phone_number: '+447900000000')
    #
    # @param [required, String] :phone_number The phone number to check, in the E.164 format, prepended with a `+`.
    #
    # @param [optional, Integer] :max_age Period in hours to be checked for SIM swap
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/camara/sim-swap#checkSimSwap
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

    # Get timestamp of last MSISDN <-> IMSI pairing change for a mobile user account provided with MSIDN.
    #
    # @example
    #   response = client.network_sim_swap.retrieve_date(phone_number: '+447900000000')
    #
    # @param [required, String] :phone_number The phone number to check, in the E.164 format, prepended with a `+`.
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/camara/sim-swap#retrieveSimSwapDate
    #
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