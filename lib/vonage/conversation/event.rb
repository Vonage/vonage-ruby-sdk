# typed: true
# frozen_string_literal: true

module Vonage
  class Conversation::Event < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # List conversation events
    #
    # @example
    #   response = client.conversation.event.list(conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a')
    #
    # @param [required, String] :conversation_id The conversation_id of the conversation to list events for
    #
    # @param [String] :start_id
    #   The ID to start returning events at
    #
    # @param [String] :end_id
    #   The ID to end returning events at
    #
    # @param [String] :event_type
    #  The type of event to search for. Does not currently support custom events
    #
    # @param [Integer] :page_size
    #   Return this amount of records in the response.
    #
    # @param ['asc', 'desc'] :order
    #   Return the records in ascending or descending order.
    #
    # @param [String] :cursor
    #   The cursor to start returning results from.
    #
    # @return [Conversation::Member::ListResponse]
    #
    # @see https://developer.vonage.com/en/api/conversation#getEvents
    #
    def list(conversation_id:, **params)  
      request("/v1/conversations/#{conversation_id}/events", params: params, response_class: ListResponse)
    end

    # Create an event
    # @example
    #   response = client.conversation.event.create(
    #     conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a',
    #     type: 'message',
    #     body: {
    #       message_type: 'text',
    #       text: 'Hello World'
    #     }
    #   )  
    #
    # @param [required, String] :conversation_id The conversation_id of the conversation to create the event for
    #
    # @param [required, String] :type
    #   Event type.
    #
    # @param [String] :from
    #
    # @option params [required, String] :from
    #
    # @param [Hash] :body
    #   The body of the event. There are many possible properties depending on the event type and message_type
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#createEvent
    #
    def create(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}/events", params: params, type: Post)
    end

    # Get details of a specific event
    #
    # @example
    #   response = client.conversation.event.find(conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a', event_id: 1) 
    #
    # @param [required, String] :conversation_id
    #
    # @param [required, String] :event_id
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#getEvent
    #
    def find(conversation_id:, event_id:)
      request("/v1/conversations/#{conversation_id}/events/#{event_id}")
    end

    # Delete an event.
    #
    # @example
    #   response = client.conversation.event.delete(conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a', event_id: 1)
    #
    # @param [String] :conversation_id
    #
    # @param [String] :event_id
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#deleteEvent
    #
    def delete(conversation_id:, event_id:)
      request("/v1/conversations/#{conversation_id}/events/#{event_id}", type: Delete)
    end
  end
end
