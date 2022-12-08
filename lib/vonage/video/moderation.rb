# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Moderation < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Force a client to disconnect from a session.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :connection_id The connection ID of the specific participant to be disconnected from the session.
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def force_disconnect(application_id: @config.application_id, session_id:, connection_id:)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/session/' + session_id + '/connection/' + connection_id, type: Delete)
    end

    # Force mute a specific publisher stream in a session.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :stream_id The stream ID of the specific stream to be muted.
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def mute_single_stream(application_id: @config.application_id, session_id:, stream_id:)
      application_id ||= @config.application_id
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/session/' + session_id + '/stream/' + stream_id + '/mute', type: Post)
    end

    # Force mute all publisher stream for a specific session.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
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
    def mute_multiple_streams(application_id: @config.application_id, session_id:, **params)
      # TODO: raise error if application_id is nil
      # TODO: camelcase params
      
      request('/v2/project/' + application_id + '/session/' + session_id + '/mute', params: params, type: Post)
    end

    # TODO: add disable_force_mute ??
  end
end
  