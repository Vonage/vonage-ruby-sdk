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
    def list(**params)
      request('/v2/project/' + @config.application_id + '/archive', params: params, response_class: ListResponse)
    end

    # Return information for specified archive.
    #
    # @param [required, String] archive_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def info(archive_id:)
      request('/v2/project/' + @config.application_id + '/archive/' + archive_id)
    end

    # Create a new archive.
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
    def start(session_id:, **params)
      request('/v2/project/' + @config.application_id + '/archive', params: camelcase(params.merge(session_id: session_id)), type: Post)
    end

    # Stop recording a specified archive.
    #
    # @param [required, String] archive_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def stop(archive_id:)
      request('/v2/project/' + @config.application_id + '/archive/' + archive_id + '/stop', type: Post)
    end

    # Delete a specified archive.
    #
    # @param [required, String] archive_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def delete(archive_id:)
      request('/v2/project/' + @config.application_id + '/archive/' + archive_id, type: Delete)
    end

    # Add a stream to a composed archive that was started with the streamMode set to "manual".
    #
    # @param [required, String] archive_id
    #
    # @param [required, String] stream_id The ID of the stream to be added
    #
    # @param [optional, Boolean] has_audio
    #
    # @param [optional, Boolean] has_video
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def add_stream(archive_id:, stream_id:, **params)
      request('/v2/project/' + @config.application_id + '/archive/' + archive_id + '/streams', params: camelcase(params.merge(addStream: stream_id)), type: Patch)
    end

    # Remove a stream from a composed archive that was started with the streamMode set to "manual".
    #
    # @param [required, String] archive_id
    #
    # @param [required, String] stream_id The ID of the stream to be removed
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    def remove_stream(archive_id:, stream_id:)
      request('/v2/project/' + @config.application_id + '/archive/' + archive_id + '/streams', params: {removeStream: stream_id}, type: Patch)
    end

    # Change the layout of a composed archive while it is being recorded.
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
    def change_layout(archive_id:, **params)
      request('/v2/project/' + @config.application_id + '/archive/' + archive_id + '/layout', params: camelcase(params), type: Put)
    end
  end
end
