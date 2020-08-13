# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Stream < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Play an audio file into a call.
    #
    # @option params [required, Array<String>] :stream_url
    #   URL of the audio file.
    #
    # @option params [Integer] :loop
    #   The number of times to play the file, 0 for infinite.
    #
    # @option params [String] :level
    #   Set the audio level of the stream in the range -1 >= level <= 1 with a precision of 0.1. The default value is 0.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#startStream
    #
    def start(id, params)
      request('/v1/calls/' + id + '/stream', params: params, type: Put)
    end

    # Stop playing an audio file into a call.
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#stopStream
    #
    def stop(id)
      request('/v1/calls/' + id + '/stream', type: Delete)
    end
  end
end
