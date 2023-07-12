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
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/meetings#getDialInNumbers
    def list
      request("/meetings/dial-in-numbers", response_class: ListResponse)
    end
  end
end
