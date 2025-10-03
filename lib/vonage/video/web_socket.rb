# typed: true
# frozen_string_literal: true

module Vonage
  class Video::WebSocket < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Start an audio connector websocket connection 
    #
    # @example
    #   response = client.video.web_socket.connect(
    #    session_id: "12312312-3811-4726-b508-e41a0f96c68f",
    #    token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJp...",
    #    websocket: {
    #       uri: 'wss://example.com/ws-endpoint',
    #       streams: ["8b732909-0a06-46a2-8ea8-074e64d43422"],
    #       headers: { property1: 'foo', property2: 'bar' },
    #       audio_rate: 16000
    #     }
    #   )
    #
    # @params [required, String] :session_id The Vonage Video session ID that includes the Vonage Video streams you want to include in the WebSocket stream.
    #   - The Audio Connector feature is only supported in routed sessions
    #
    # @param [required, String] :token A valid Vonage Video token for the Audio Connector connection to the Vonage Video Session.
    #   - You can add additional data to the JWT to identify that the connection is the Audio Connector endpoint or for any other identifying data.
    #
    # @params [required, Hash] :websocket The WebSocket configuration for the Audio Connector connection.
    # @option websocket [required, String] :uri A publicly reachable WebSocket URI to be used for the destination of the audio stream
    # @option websocket [optional, String] :streams An array of stream IDs for the Vonage Video streams you want to include in the WebSocket audio.
    #   - If you omit this property, all streams in the session will be included.
    # @option websocket [optional, Hash] :headers An object of key-value pairs of headers to be sent to your WebSocket server with each message, with a maximum length of 512 bytes.
    # @option websocket [optional, Integer] :audio_rate A number representing the audio sampling rate in Hz
    #   - Must be one of: 8000, 16000
    # @option websocket [optional, Boolean] :bidirectional Whether to send audio data from the WebSocket connection to a stream published in the session.
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
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
