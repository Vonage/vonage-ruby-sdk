# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Connections < Namespace

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Get a list of connections for a specified session.
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
      request('/v2/project/' + @config.application_id + '/session/' + session_id + '/connection', response_class: ListResponse)
    end
  end
end
