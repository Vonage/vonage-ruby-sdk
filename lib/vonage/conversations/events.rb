# typed: true
# frozen_string_literal: true

module Vonage
  class Conversations::Events < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Create an event.
    #
    # @deprecated Please use {Vonage::Conversation::Event#create} instead
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
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Event#create` instead.')
      request('/beta/conversations/' + conversation_id + '/events', params: params, type: Post)
    end

    # List events.
    #
    # @deprecated Please use {Vonage::Conversation::Event#list} instead
    #
    # @param [String] conversation_id
    #
    # @option params [Boolean] :auto_advance
    #   Set this to `false` to not auto-advance through all the pages in the record
    #   and collect all the data. The default is `true`.
    #    
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getEvents
    #
    def list(conversation_id, params = nil, auto_advance = true)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Event#list` instead.')
      request('/beta/conversations/' + conversation_id + '/events', params: params)
    end

    # Retrieve an event.
    #
    # @deprecated Please use {Vonage::Conversation::Event#find} instead
    #
    # @param [String] conversation_id
    # @param [String] event_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getEvent
    #
    def get(conversation_id, event_id)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Event#find` instead.')
      request('/beta/conversations/' + conversation_id + '/events/' + event_id.to_s)
    end

    # Delete an event.
    #
    # @deprecated Please use {Vonage::Conversation::Event#delete} instead
    #
    # @param [String] conversation_id
    # @param [String] event_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteEvent
    #
    def delete(conversation_id, event_id)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Event#delete` instead.')
      request('/beta/conversations/' + conversation_id + '/events/' + event_id.to_s, type: Delete)
    end
  end
end
