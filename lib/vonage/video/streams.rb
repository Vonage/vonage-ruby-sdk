# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Streams < Namespace

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Get a list of streams for a specified session.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # TODO: add auto_advance option
    #
    # @return [ListResponse]
    #
    # @see TODO: add docs link
    #
    def list(session_id:)
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/stream', response_class: ListResponse)
    end

    # Get information about a specified stream.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # @param [required, String] :stream_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def info(session_id:, stream_id:)
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/stream/' + stream_id)
    end

    # Change the layout for a list of specified streams.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # @param [optional, Array<Hash>] :items An array of hashes representing streams and the layout classes for those streams
    #
    # @option items [required, String] :id The stream ID
    #
    # @option items [required, Array<String>] :layoutClassList Array of CSS class names as strings
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def change_layout(session_id:, **params)
      # TODO camelcase layout_class_list
      # if params[:items]
      #   params[:items] = params[:items].map {|item| camelcase(item)}
      # end

      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/stream', params: params, type: Put)
    end
  end
end
