# typed: true
# frozen_string_literal: true

module Vonage
  class Voice::Talk < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Play text to speech into a call.
    #
    # @option params [required, String] :text
    #   The text to read.
    #
    # @option params [String] :voice_name
    #   The voice & language to use.
    #
    # @option params [Integer] :loop
    #   The number of times to repeat the text the file, 0 for infinite.
    #
    # @option params [String] :level
    #   The volume level that the speech is played.
    #   This can be any value between `-1` to `1` in `0.1` increments, with `0` being the default.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#startTalk
    #
    def start(id, params)
      request('/v1/calls/' + id + '/talk', params: params, type: Put)
    end

    # Stop text to speech in a call.
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#stopTalk
    #
    def stop(id)
      request('/v1/calls/' + id + '/talk', type: Delete)
    end
  end
end
