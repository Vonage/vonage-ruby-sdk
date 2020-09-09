# typed: true
# frozen_string_literal: true

module Vonage
  class Conversations::Events < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Create an event.
    #
    # @option params [required, String] :type
    #   Event type.
    #
    # @option params [String] :to
    #   Member ID.
    #
    # @option params [required, String] :from
    #   Member ID.
    #
    # @option params [Hash] :body
    #   Event Body.
    #
    # @param [String] conversation_id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#createEvent
    #
    def create(conversation_id, params)
      request('/beta/conversations/' + conversation_id + '/events', params: params, type: Post)
    end

    # List events.
    #
    # @param [String] conversation_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getEvents
    #
    def list(conversation_id)
      request('/beta/conversations/' + conversation_id + '/events')
    end

    # Retrieve an event.
    #
    # @param [String] conversation_id
    # @param [String] event_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getEvent
    #
    def get(conversation_id, event_id)
      request('/beta/conversations/' + conversation_id + '/events/' + event_id.to_s)
    end

    # Delete an event.
    #
    # @param [String] conversation_id
    # @param [String] event_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteEvent
    #
    def delete(conversation_id, event_id)
      request('/beta/conversations/' + conversation_id + '/events/' + event_id.to_s, type: Delete)
    end
  end
end
