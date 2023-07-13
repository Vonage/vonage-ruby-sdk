# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Recordings < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :vonage_host

    # Return information for specified recording.
    #
    # @param [required, String] recording_id The id of the recoring for which the info should be returned
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#getRecording
    def info(recording_id:)
      request("/meetings/recordings/" + recording_id)
    end

    # Delete a specified recording.
    #
    # @param [required, String] recording_id The id of the recoring to be deleted
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#deleteRecording
    def delete(recording_id:)
      request("/meetings/recordings/" + recording_id, type: Delete)
    end
  end
end
