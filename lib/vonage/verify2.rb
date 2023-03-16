# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2 < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Request a verification be sent to a user.
    #
    # @see https://developer.vonage.com/en/api/verify.v2#newRequest
    #
    def start_verfication(workflow:, **opts)
    end

    # Check a supplied code against a request to see if it is valid.
    #
    # @see https://developer.vonage.com/en/api/verify.v2#checkCode
    #
    def check_code(request_id:, code:)
    end
  end
end
