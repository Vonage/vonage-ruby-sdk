# typed: true
# frozen_string_literal: true

module Vonage
  class NetworkAuthentication::Server < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_headers['Content-Type'] = 'application/x-www-form-urlencoded'

    def generate_token(**params)
      auth_request_id = bc_authorize(**params).auth_request_id

      token(
        grant_type: 'urn:openid:params:grant-type:ciba',
        auth_req_id: auth_request_id
      ).access_token
    end

    def bc_authorize(purpose:, api_scope:, login_hint:)
      scope = "openid+dpv:#{purpose}##{api_scope}"
      request(
        "/oauth2/bc-authorize",
        params: {
          scope: scope,
          login_hint: login_hint
        },
        type: Post
      )
    end
  end
end