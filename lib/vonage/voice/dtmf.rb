# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::DTMF < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Play DTMF tones into a call.
    #
    # @option params [String] :digits
    #   The digits to send.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#startDTMF
    #
    def send(id, params)
      request('/v1/calls/' + id + '/dtmf', params: params, type: Put)
    end
  end
end
