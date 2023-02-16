# typed: true
# frozen_string_literal: true

module Vonage
  class Video::SIP < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Initiate an outbound SIP call.
    #
    def dial(session_id:, token:, sip_uri:, **params)
      request(
        '/v2/project/' + @config.application_id + '/dial',
        params: camelcase({
          session_id: session_id,
          token: token,
          sip: params.merge({uri: sip_uri})
          }),
        type: Post
      )
    end

    # Play DTMF tones into a SIP call.
    #
    def play_dtmf_to_session(session_id:, dtmf_digits:)
      request(
        '/v2/project/' + @config.application_id + '/session/' + session_id + '/play-dtmf',
        params: {digits: dtmf_digits},
        type: Post
      )
    end

    # Play DMTF tones into a specific connection.
    #
    def play_dtmf_to_connection(session_id:, connection_id:, dtmf_digits:)
      request(
        '/v2/project/' + @config.application_id + '/session/' + session_id + '/connection/' + connection_id + '/play-dtmf',
        params: {digits: dtmf_digits},
        type: Post
      )
    end
  end
end
