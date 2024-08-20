# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::DialInNumbers < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :vonage_host

    # Get numbers that can be used to dial into a meeting.
    #
    # @deprecated
    #
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/meetings#getDialInNumbers
    def list
      logger.info('This method is deprecated and will be removed in a future release.')
      request("/v1/meetings/dial-in-numbers", response_class: ListResponse)
    end
  end
end
