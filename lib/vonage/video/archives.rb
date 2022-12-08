# typed: true
# frozen_string_literal: true

module Vonage
  class Video::Archives < Namespace
    include Keys

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :video_host

    # Get a list of archives for a specified Vonage application.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [optional, Integer] :offset
    #
    # @param [optional, Integer] :count
    #
    # @param [optional, String] :session_id
    #
    # TODO: add auto_advance option
    #
    # @return [ListResponse]
    #
    # @see TODO: add docs link
    #
    def list(application_id: @config.application_id, **params)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/archive', params: params, response_class: Video::ListResponse)
    end

    # Return information for specified archive.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] archive_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def info(application_id: @config.application_id, archive_id:)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/archive/' + archive_id)
    end

    # Create a new archive.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] :session_id
    #
    # @param [optional, String] :hasAudio
    #
    # @param [optional, String] :hasVideo
    #
    # @param [optional, String] :name
    #
    # @param [optional, String] :outputMode
    #
    # @param [optional, String] :resolution
    #
    # @param [optional, String] :streamMode
    #
    # @param [optional, String] :multiArchiveTag
    #
    # @param [optional, Hash] :layout
    #
    # @option layout [optional, String] :type
    #
    # @option layout [optional, String] :stylesheet
    #
    # @option layout [optional, String] :screenshareType
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def start(application_id: @config.application_id, **params)
      # TODO: raise error if application_id is nil
      # TODO: raise error if session_id is nil

      request('/v2/project/' + application_id + '/archive', params: params, type: Post)
    end

    # Stop recording a specified archive.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] archive_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def stop(application_id: @config.application_id, archive_id:)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/archive/' + archive_id + '/stop', type: Post)
    end

    # Delete a specified archive.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] archive_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def delete(application_id: @config.application_id, archive_id:)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/archive/' + archive_id, type: Delete)
    end

    # Add a stream to a composed archive that was started with the streamMode set to "manual".
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] archive_id
    #
    # @param [required, String] add_stream The ID of the stream to be added
    #
    # @param [optional, Boolean] has_audio
    #
    # @param [optional, Boolean] has_video
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def add_stream(application_id: @config.application_id, archive_id:, **params)
      # TODO: raise error if application_id is nil
      # TODO: raise error if add_stream is nil

      request('/v2/project/' + application_id + '/archive/' + archive_id + '/streams', params: camelcase(params), type: Patch)
    end

    # Remove a stream from a composed archive that was started with the streamMode set to "manual".
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] archive_id
    #
    # @param [required, String] remove_stream The ID of the stream to be removed
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def remove_stream(application_id: @config.application_id, archive_id:, **params)
      # TODO: raise error if application_id is nil
      # TODO: raise error if remove_stream is nil

      request('/v2/project/' + application_id + '/archive/' + archive_id + '/streams', params: camelcase(params), type: Patch)
    end

    # Change the layout of a composed archive while it is being recorded.
    #
    # @param [optional, String] :application_id (Required unless already set at Client instantiation or set in ENV)
    #
    # @param [required, String] archive_id
    #
    # @param [optional, String] type
    #
    # @param [optional, String] stylesheet
    #
    # @param [optional, String] screenshare_type
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def change_layout(application_id: @config.application_id, archive_id:, **params)
      # TODO: raise error if application_id is nil

      request('/v2/project/' + application_id + '/archive/' + archive_id + '/layout', params: camelcase(params), type: Put)
    end
  end
end
