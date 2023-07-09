# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Recordings < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :meetings_host

    # Return information for specified recording.
    #
    # @param [required, String] recording_id (The id of the recoring for which the info should be returned)
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def info(recording_id:)
      request("/beta/meetings/recordings/" + recording_id)
    end

    # Delete a specified recording.
    #
    # @param [required, String] recording_id (The id of the recoring to be deleted)
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def delete(recording_id:)
      request("/beta/meetings/recordings/" + recording_id, type: Delete)
    end
  end
end
