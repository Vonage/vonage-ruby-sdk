# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Sessions < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :vonage_host

    # Return a list of recordings for a specified session.
    #
    # @deprecated
    #
    # @param [required, String] session_id The id of the session for which the recordings list should be returned
    #
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/meetings#getSessionRecordings
    def list_recordings(session_id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request(
        "/v1/meetings/sessions/" + session_id + "/recordings",
        response_class: ListResponse
      )
    end
  end
end
