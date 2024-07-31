# typed: true
# frozen_string_literal: true

module Vonage
  class NetworkAuthentication::ClientAuthentication < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_headers['Content-Type'] = 'application/x-www-form-urlencoded'

    def token(oidc_auth_code:, redirect_uri:, **params)
      request(
        '/oauth2/token',
        params: {
          grant_type: 'authorization_code',
          code: oidc_auth_code,
          redirect_uri: redirect_uri
        },
        type: Post
      ).access_token
    end

    def generate_oidc_uri(purpose:, api_scope:, login_hint:, redirect_uri:, state: nil)
      scope = "openid+dpv:#{purpose}##{api_scope}"
      uri = "https://oidc.idp.vonage.com/oauth2/auth?" +
        "client_id=#{@config.application_id}" +
        "&response_type=code" +
        "&scope=#{scope}" +
        "&login_hint=#{login_hint}" +
        "&redirect_uri=#{redirect_uri}"

      uri += "&state=#{state}" if state
      uri
    end
  end
end