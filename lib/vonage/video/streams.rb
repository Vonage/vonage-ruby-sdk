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
    def list(application_id: @config.application_id, session_id:)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/session/' + session_id + '/stream', response_class: Video::ListResponse)
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
    def info(application_id: @config.application_id, session_id:, stream_id:)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/session/' + session_id + '/stream/' + stream_id)
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
    def change_layout(application_id: @config.application_id, session_id:, **params)
      # TODO: raise error if application_id is nil
      # TODO camelcase layout_class_list
      # if params[:items]
      #   params[:items] = params[:items].map {|item| camelcase(item)}
      # end

      request('/v2/project/' + application_id + '/session/' + session_id + '/stream', params: params, type: Put)
    end
  end
end
  