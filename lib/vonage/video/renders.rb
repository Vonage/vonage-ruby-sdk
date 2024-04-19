# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Renders < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Start an Experience Composer Render
    #
    # @example
    #   response = client.video.renders.start(
    #     session_id: "12312312-3811-4726-b508-e41a0f96c68f",
    #     token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJp...",
    #     url: 'https://example.com/',
    #     max_duration: 1800,
    #     resolution: '1280x720',
    #     properties: {
    #       name: 'foo'
    #     }
    #   )
    #
    # @params [required, String] :session_id The session ID of the Vonage Video session you are working with.
    #
    # @param [required, String] :token A valid OpenTok JWT token with a Publisher role and (optionally) connection data to be associated with the output stream.
    #
    # @params [required, String] :url A publicly reachable URL controlled by the customer and capable of generating the content to be rendered without user intervention.
    #
    # @params [optional, Integer] :max_duration The maximum duration of the rendered video in seconds. 
    #   - After this time, it is stopped automatically, if it is still running.
    #     - Min: 60
    #     - Max: 3600
    #     - Default: 3600
    #
    # @params [optional, String] :resolution The resolution of the Experience Composer render.
    #   - Must be one of: '640x480', '480x640', '1280x720', '720x1280', '1080x1920', '1920x1080'
    #
    # @params [optional, Hash] :properties The initial configuration of Publisher properties for the composed output stream.
    # @option properties [required, String] :name The name of the composed output stream which is published to the session.
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
    def start(session_id:, token:, url:, **params)
      request(
        '/v2/project/' + @config.application_id + '/render',
        params: camelcase(params.merge({sessionId: session_id, token: token, url: url})),
        type: Post)
    end

    # Stop an Experience Composer render
    #
    # @example
    #   response = client.video.renders.stop(experience_composer_id: "1248e7070b81464c9789f46ad10e7764")
    #
    # @params [required, String] :experience_composer_id ID of the Experience Composer instance that you want to stop.
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
    def stop(experience_composer_id:)
      request('/v2/project/' + @config.application_id + '/render/' + experience_composer_id, type: Delete)
    end

    # Get information about an Experience Composer session 
    #
    # @example
    #   response = client.video.renders.info(experience_composer_id: "1248e7070b81464c9789f46ad10e7764")
    #
    # @params [required, String] :experience_composer_id ID of the Experience Composer instance for which you are requesitng information.
    #
    # @return [Response]
    #
    # @see TODO: Add document link here
    #
    def info(experience_composer_id:)
      request('/v2/project/' + @config.application_id + '/render/' + experience_composer_id)
    end

    # List all Experience Composer renders in an application 
    #
    # @example
    #   response = client.video.renders.list
    #
    # @params [optional, Integer] :offset Specify the index offset of the first experience composer. 0 is offset of the most recently started render.
    #
    # @params [optional, Integer] :count Limit the number of experience composers to be returned.
    #
    # @return [Video::Renders::ListResponse]
    #
    # @see TODO: Add document link here
    #
    def list(**params)
      path = '/v2/project/' + @config.application_id + '/render'
      path += "?#{Params.encode(camelcase(params))}" unless params.empty?

      request(path, response_class: ListResponse)
    end
  end
end
