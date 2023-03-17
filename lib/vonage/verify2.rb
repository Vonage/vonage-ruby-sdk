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
    def start_verfication(brand:, workflow:, **opts)
      raise ArgumentError, ':workflow must be an Array' unless workflow.is_a?(Array)
      raise ArgumentError, ':workflow must not be empty' if workflow.empty?

      request('/v2/verify/', params: opts.merge(brand: brand, workflow: workflow), type: Post)
    end

    # Check a supplied code against a request to see if it is valid.
    #
    # @see https://developer.vonage.com/en/api/verify.v2#checkCode
    #
    def check_code(request_id:, code:)
      request('/v2/verify/' + request_id, params: {code: code}, type: Post)
    end
  end
end
