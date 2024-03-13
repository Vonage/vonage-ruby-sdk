# typed: true
# frozen_string_literal: true

module Vonage
  class Conversation::User < Namespace
    self.authentication = BearerToken

    # List conversations associated with a user.
    #
    # @example
    #   response = client.conversation.user.list_conversations(user_id: 'USR-82e028d9-5201-4f1e-8188-604b2d3471ec')
    #
    # @param [required, String] :user_id The user_id of the user to list conversations for
    #
    # @param [String] :state Must be one of ['INVITED', 'JOINED', 'LEFT']
    #
    # @param [String] :order_by Must be one of ['created', 'custom_sort_key']
    #
    # @param [Boolean] :include_custom_data
    # @param [String] :date_start
    #   Return the records that occurred after this point in time.
    #
    # @param [String] :date_start
    #   Return the records that occurred after this point in time.
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
    # @return [Conversation::User::ConversationsListResponse]
    #
    # @see https://developer.vonage.com/en/api/conversation#getuserConversations
    #
    def list_conversations(user_id:, **params)
      request("/v1/users/#{user_id}/conversations", params: params, response_class: ConversationsListResponse)
    end

    # List conversations associated with a user.
    #
    # @example
    #   response = client.conversation.user.list_sessions(user_id: 'USR-82e028d9-5201-4f1e-8188-604b2d3471ec')
    #
    # @param [required, String] :user_id The user_id of the user to list sessions for
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
    # @return [Conversation::User::SessionsListResponse]
    #
    # @see https://developer.vonage.com/en/api/conversation#getuserSessions
    #
    def list_sessions(user_id:, **params)
      request("/v1/users/#{user_id}/sessions", params: params, response_class: SessionsListResponse)
    end
  end
end
