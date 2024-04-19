# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Captions < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Start Live Captions for a Vonage Video stream
    #
    # @example
    #   response = client.video.captions.start(
    #     session_id: "12312312-3811-4726-b508-e41a0f96c68f",
    #     token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJp...",
    #     language_code: 'en-US',
    #     max_duration: 300,
    #     partial_captions: false,
    #     status_callback_url: 'https://example.com/captions/status'
    #   )
    #
    # @params [required, String] :session_id The id of the session to start captions for
    #
    # @param [required, String] :token A valid Vonage Video token with role set to 'moderator'
    #
    # @params [optional, String] :language_code The BCP-47 code for a spoken language used on this call. The default value is "en-US"
    #   - Must be one of: 'en-US', 'en-AU', 'en-GB', 'zh-CN', 'fr-FR', 'fr-CA', 'de-DE', 'hi-IN', 'it-IT', 'ja-JP', 'ko-KR', 'pt-BR', 'th-TH'
    #
    # @param [optional, Integer] :max_duration The maximum duration for the audio captioning, in seconds.
    #   - The default value is 14,400 seconds (4 hours), the maximum duration allowed.
    #   - The minimum value for maxDuration is 300 (300 seconds, or 5 minutes).
    #
    # @param [optional, Boolean] :partial_captions Whether to enable this to faster captioning (true, the default) at the cost of some degree of inaccuracies.
    #
    # @param [optional, String] :status_callback_url The URL to send the status of the captions to.
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
    def start(session_id:, token:, **params)
      request(
        '/v2/project/' + @config.application_id + '/captions',
        params: camelcase(params.merge({sessionId: session_id, token: token})),
        type: Post)
    end

    # Stop live captions for a session
    #
    # @example
    #   response = client.video.captions.stop(captions_id: "7c0580fc-6274-4de5-a66f-d0648e8d3ac3")
    #
    # @params [required, String] :captions_id ID of the connection used for captions
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
    def stop(captions_id:)
      request('/v2/project/' + @config.application_id + '/captions/' + captions_id + '/stop', type: Post)
    end
  end
end
