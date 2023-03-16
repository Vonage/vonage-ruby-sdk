# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2 < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Request a verification be sent to a user .
    #
    # @see https://developer.vonage.com/en/api/verify.v2#newRequest
    #
    def start_verfication(workflow:, **opts)
    end

    def check_code(request_id:, code:)
    end
  end
end
