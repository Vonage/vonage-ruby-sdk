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
    end

    # Return information for specified broadcast.
    #
    def info(broadcast_id:)
    end

    # Start a new live streaming broadcast.
    #
    def start(**params)
    end

    # Stop a specified broadcast.
    #
    def stop(broadcast_id:)
    end

    # Add a stream to a live streaming broadcast.
    #

    def add_stream(broadcast_id:, **params)
    end

    # Remove a stream from a live streaming broadcast.
    #
    def remove_stream(broadcast_id:, **params)
    end

    # Dynamically change layout of a broadcast.
    #
    def change_layout(broadcast_id:, **params)
    end
  end
end
