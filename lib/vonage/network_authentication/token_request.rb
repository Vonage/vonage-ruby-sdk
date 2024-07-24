# typed: true
# frozen_string_literal: true

module Vonage
  module NetworkAuthentication::TokenRequest
    extend T::Sig

    # Request an authentication token for use with Network APIs.
    #
    # @see https://developer.vonage.com/en/api/camara/auth#token
    def token(**params)
      request(
        '/oauth2/token',
        params: params,
        type: Post
      )
    end
  end
end