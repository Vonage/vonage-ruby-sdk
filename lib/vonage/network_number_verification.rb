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

    # Verifies if the specified phone number (plain text or hashed format) matches the one that the user is currently using.
    #
    # @example
    #   response = client.network_number_verification.verify(
    #     phone_number: '+447900000000',
    #     auth_data: {
    #       oidc_auth_code: '0dadaeb4-7c79-4d39-b4b0-5a6cc08bf537',
    #       redirect_uri: 'https://example.com/callback'
    #     }
    #   )
    #
    # @param [required, String] :phone_number The phone number to check, in the E.164 format, prepended with a `+`.
    #
    # @param [required, Hash] :auth_data A hash of authentication data required for the client token request. Must contain the following keys:
    # @option auth_data [required, String] :oidc_auth_code The OIDC auth code.
    # @option auth_data [required, String] :redirect_uri The redirect URI.
    # @see https://developer.vonage.com/en/getting-started-network/authentication#client-authentication-flow
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/camara/number-verification#verifyNumberVerification
    #
    sig { params(phone_number: String, auth_data: Hash).returns(Vonage::Response) }
    def verify(phone_number:, auth_data:)
      raise ArgumentError.new("`phone_number` must be in E.164 format") unless Phonelib.parse(phone_number).valid?
      raise ArgumentError.new("`phone_number` must be prepended with a `+`") unless phone_number.start_with?('+')
      raise ArgumentError.new("`auth_data` must contain key `:oidc_auth_code`") unless auth_data.has_key?(:oidc_auth_code)
      raise ArgumentError.new("`auth_data[:oidc_auth_code]` must be a String") unless auth_data[:oidc_auth_code].is_a?(String)
      raise ArgumentError.new("`auth_data` must contain key `:redirect_uri`") unless auth_data.has_key?(:redirect_uri)
      raise ArgumentError.new("`auth_data[:redirect_uri]` must be a String") unless auth_data[:redirect_uri].is_a?(String)

      params = {phone_number: phone_number}

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

    # Creates a URL for a client-side OIDC request.
    #
    # @example
    #   response = client.network_number_verification.generate_oidc_uri(
    #     phone_number: '+447900000000',
    #     redirect_uri: 'https://example.com/callback'
    #   )
    #
    # @param [required, String] :phone_number The phone number that will be checked during the verification request.
    #
    # @param [required, String] :redirect_uri The URI that will receive the callback containing the OIDC auth code.
    #
    # @param [required, String] :state A string that you can use for tracking. 
    #   Used to set a unique identifier for each access token you generate.
    #
    # @return [String]
    #
    # @see https://developer.vonage.com/en/getting-started-network/authentication#1-make-an-oidc-request
    sig { params(phone_number: String, redirect_uri: String, state: String).returns(String) }
    def generate_oidc_uri(phone_number:, redirect_uri:, state:)
      params = {
        purpose: 'FraudPreventionAndDetection',
        api_scope: 'number-verification-verify-read',
        login_hint: phone_number,
        redirect_uri: redirect_uri,
        state: state
      }

      Vonage::NetworkAuthentication::ClientAuthentication.new(@config).generate_oidc_uri(**params)
    end
  end
end