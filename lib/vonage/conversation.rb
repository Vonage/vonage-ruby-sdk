# typed: strict
# frozen_string_literal: true

module Vonage
  class Conversation < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    # List conversations associated with a Vonage application.
    #
    # @example
    #   response = client.conversation.list
    #
    # @param [String] :date_start
    #   Return the records that occurred after this point in time.
    #
    # @param [String] :date_end
    #   Return the records that occurred before this point in time.
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
    # @return [Conversation::ListResponse]
    #
    # @see https://developer.vonage.com/en/api/conversation#listConversations
    #
    def list(**params)
      request('/v1/conversations', params: params, response_class: ListResponse)
    end

    # Create a conversation.
    #
    # @example
    #   response = client.conversation.create(name: 'Example Conversation', display_name: 'Example Display Name')
    #
    # @param [String] :name
    #   Your internal conversation name. Must be unique.
    #
    # @param [String] :display_name
    #   The public facing name of the conversation.
    #
    # @param [String] :image_url
    #   An image URL that you associate with the conversation
    #
    # @param [Hash] :properties
    #   - :ttl (Integer) After how many seconds an empty conversation is deleted
    #   - :type (String)
    #   - :custom_sort_key (String)
    #   - :custom_data (Hash) Custom key/value pairs to be included with conversation data
    #
    # @option params [Array] :numbers An array of Hashes containing number information for different channels.
    #
    # @option params [Hash] :callback
    #   - @option callback :url (String)
    #   - @option callback :event_mask (String)
    #   - @option callback :params (Hash)
    #     - @option params :applicationId (String)
    #     - @option params :ncco_url (String)
    #   - @option callback :method (String) Must be one of ['POST', 'GET']
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#createConversation
    #
    def create(**params)
      request('/v1/conversations', params: params, type: Post)
    end

    # Retrieve a conversation.
    #
    # @example
    #   response = client.conversation.find(conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a')
    #
    # @param [String] :conversation_id
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#retrieveConversation
    #
    def find(conversation_id:)
      request("/v1/conversations/#{conversation_id}")
    end

    # Update a conversation.
    #
    # @example
    #   response = client.conversation.update(conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a', display_name: 'Updated conversation')
    #
    # @param [String] :name
    #   Your internal conversation name. Must be unique.
    #
    # @param [String] :display_name
    #   The public facing name of the conversation.
    #
    # @param [String] :image_url
    #   An image URL that you associate with the conversation
    #
    # @param [Hash] :properties
    #   - @option properties :ttl (Integer) After how many seconds an empty conversation is deleted
    #   - @option properties :type (String)
    #   - @option properties :custom_sort_key (String)
    #   - @option properties :custom_data (Hash) Custom key/value pairs to be included with conversation data
    #
    # @param [Array] :numbers An array of Hashes containing number information for different channels.
    #
    # @option params [Hash] :callback
    #   - @option callback :url (String)
    #   - @option callback :event_mask (String)
    #   - @option callback :params (Hash)
    #     - @option params :applicationId (String)
    #     - @option params :ncco_url (String)
    #   - @option callback :method (String) Must be one of ['POST', 'GET']
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#replaceConversation
    #
    def update(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}", params: params, type: Put)
    end

    # Delete a conversation.
    #
    # @example
    #   response = client.conversation.delete(conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a')
    #
    # @param [String] :conversation_id
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#deleteConversation
    #
    def delete(conversation_id:)
      request("/v1/conversations/#{conversation_id}", type: Delete)
    end

    # @return [Conversation::User]
    sig { returns(T.nilable(Vonage::Conversation::User)) }
    def user
      @user ||= User.new(@config)
    end

    # @return [Conversation::Member]
    sig { returns(T.nilable(Vonage::Conversation::Member)) }
    def member
      @member ||= Member.new(@config)
    end

    # @return [Conversation::Event]
    sig { returns(T.nilable(Vonage::Conversation::Event)) }
    def event
      @event ||= Event.new(@config)
    end
  end
end
