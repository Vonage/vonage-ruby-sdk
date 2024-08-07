# typed: true
# frozen_string_literal: true

module Vonage
  class NetworkAuthentication::ServerAuthentication < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_headers['Content-Type'] = 'application/x-www-form-urlencoded'

    def token(purpose:, api_scope:, login_hint:, **params)
      auth_req_id = bc_authorize(
        purpose: purpose,
        api_scope: api_scope,
        login_hint: login_hint
      ).auth_req_id

      request_access_token(auth_req_id: auth_req_id).access_token
    end

    def bc_authorize(purpose:, api_scope:, login_hint:)
      scope = "openid dpv:#{purpose}##{api_scope}"
      request(
        "/oauth2/bc-authorize",
        params: {
          scope: scope,
          login_hint: login_hint
        },
        type: Post
      )
    end

    def request_access_token(auth_req_id:)
      request(
        "/oauth2/token",
        params: {
          grant_type: 'urn:openid:params:grant-type:ciba',
          auth_req_id: auth_req_id
        },
        type: Post
      )
    end
  end
end