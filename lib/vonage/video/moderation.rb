# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Moderation < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Force a client to disconnect from a session.
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :connection_id The connection ID of the specific participant to be disconnected from the session.
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def force_disconnect(session_id:, connection_id:)
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/connection/' + connection_id, type: Delete)
    end

    # Force mute a specific publisher stream in a session.
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :stream_id The stream ID of the specific stream to be muted.
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def mute_single_stream(session_id:, stream_id:)
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/stream/' + stream_id + '/mute', type: Post)
    end

    # Force mute all publisher stream for a specific session.
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :active
    #
    # @param [required, Array<String>] :excludedStreamIds
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def mute_multiple_streams(session_id:, **params)
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/mute', params: params, type: Post)
    end

    # TODO: add disable_force_mute ??
  end
end
