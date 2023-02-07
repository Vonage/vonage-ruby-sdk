# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::DialInNumbers < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :meetings_host

    # Get numbers that can be used to dial into a meeting.
    #
    # @return [ListResponse]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def list
      request("/beta/meetings/dial-in-numbers", response_class: ListResponse)
    end
  end
end
