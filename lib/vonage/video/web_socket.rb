# typed: true
# frozen_string_literal: true

module Vonage
  class Video::WebSocket < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    def connect(session_id:, token:, websocket:)
      raise ArgumentError, 'websocket must be a Hash' unless websocket.is_a?(Hash)
      raise ArgumentError, 'websocket must contain a uri' unless websocket.key?(:uri)
      
      request(
        '/v2/project/' + @config.application_id + '/connect',
        params: {
          sessionId: session_id,
          token: token,
          websocket: camelcase(websocket)
        },
        type: Post
      )
    end
  end
end
