# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Broadcasts < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Get a list of live streaming broadcasts for a specified Vonage application.
    #
    def list(**params)
      path = '/v2/project/' + @config.application_id + '/broadcast'
      path += "?#{Params.encode(camelcase(params))}" unless params.empty?

      request(path, response_class: ListResponse)
    end

    # Return information for specified broadcast.
    #
    def info(broadcast_id:)
      request('/v2/project/' + @config.application_id + '/broadcast/' + broadcast_id)
    end

    # Start a new live streaming broadcast.
    #
    def start(session_id:, **params)
      request(
        '/v2/project/' + @config.application_id + '/broadcast',
        params: camelcase(params.merge(session_id: session_id)),
        type: Post
      )
    end

    # Stop a specified broadcast.
    #
    def stop(broadcast_id:)
      request('/v2/project/' + @config.application_id + '/broadcast/' + broadcast_id + '/stop', type: Post)
    end

    # Add a stream to a live streaming broadcast.
    #

    def add_stream(broadcast_id:, stream_id:, **params)
      request(
        '/v2/project/' + @config.application_id + '/broadcast/' + broadcast_id + '/streams',
        params: camelcase(params.merge(addStream: stream_id)),
        type: Patch
      )
    end

    # Remove a stream from a live streaming broadcast.
    #
    def remove_stream(broadcast_id:, stream_id:)
      request(
        '/v2/project/' + @config.application_id + '/broadcast/' + broadcast_id + '/streams',
        params: {removeStream: stream_id},
        type: Patch
      )
    end

    # Dynamically change layout of a broadcast.
    #
    def change_layout(broadcast_id:, **params)
      request(
        '/v2/project/' + @config.application_id + '/broadcast/' + broadcast_id + '/layout',
        params: camelcase(params),
        type: Put)
    end
  end
end
