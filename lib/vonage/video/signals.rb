# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Signals < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Send a signal to a specific participant in an active Vonage Video session.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :connection_id The connection ID of the specific participant.
    #
    # @param [required, String] :type Type of data that is being sent to the client.
    #
    # @param [required, String] :data Payload that is being sent to the client.
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def send_to_one(session_id:, connection_id:, **params)
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/connection/' + connection_id + '/signal', params: params, type: Post)
    end

    # Send a signal to all participants in an active Vonage Video session.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :type Type of data that is being sent to the client.
    #
    # @param [required, String] :data Payload that is being sent to the client.
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def send_to_all(session_id:, **params)
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/signal', params: params, type: Post)
    end
  end
end
