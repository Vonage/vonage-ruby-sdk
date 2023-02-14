# typed: true
# frozen_string_literal: true

module Vonage
  class Video::SIP < Namespace

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Initiate an outbound SIP call.
    #
    def dial(session_id:, sip_uri:, **params)
    end

    # Play DTMF tones into a SIP call.
    #
    def play_dtmf_to_session(session_id:, dtmf_digits:)
    end

    # Play DMTF tones into a specific connection.
    #
    def play_dtmf_to_connection(session_id:, connection_id:, dtmf_digits:)
    end
  end
end
