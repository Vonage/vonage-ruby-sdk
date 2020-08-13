# typed: strict
# frozen_string_literal: true

module Vonage
  class Conversations < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    # Create a conversation.
    #
    # @example
    #   response = client.conversations.create(name: 'Example Conversation', display_name: 'Example Display Name')
    #
    # @option params [String] :name
    #   Unique name for a conversation.
    #
    # @option params [String] :display_name
    #   The display name for the conversation.
    #   It does not have to be unique.
    #
    # @option params [String] :image_url
    #   A link to an image for conversations' and users' avatars.
    #
    # @option params [Hash] :numbers
    #   - **:sms** (String) phone number used for sms channel
    #   - **:pstn** (String) phone number used for pstn channel
    #
    # @option params [Hash] :properties
    #   - **:ttl** (Integer) After how many seconds an empty conversation is deleted
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#createConversation
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def create(params)
      request('/beta/conversations', params: params, type: Post)
    end

    # List all conversations associated with your application.
    #
    # @example
    #   response = client.conversations.list
    #
    # @option params [String] :date_start
    #   Return the records that occurred after this point in time.
    #
    # @option params [String] :date_end
    #   Return the records that occurred before this point in time.
    #
    # @option params [Integer] :page_size
    #   Return this amount of records in the response.
    #
    # @option params [Integer] :record_index
    #   Return calls from this index in the response.
    #
    # @option params ['asc', 'desc'] :order
    #   Return the records in ascending or descending order.
    #
    # @param [Hash, nil] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#replaceConversation
    #
    sig { params(params: T.nilable(T::Hash[Symbol, T.untyped])).returns(Vonage::Response) }
    def list(params = nil)
      request('/beta/conversations', params: params)
    end

    # Retrieve a conversation.
    #
    # @example
    #   response = client.conversations.get(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#retrieveConversation
    #
    sig { params(id: String).returns(Vonage::Response) }
    def get(id)
      request('/beta/conversations/' + id)
    end
  
    # Update a conversation.
    #
    # @example
    #   response = client.conversations.update(id, display_name: 'Updated conversation')
    #
    # @option params [String] :name
    #   Unique name for a conversation
    #
    # @option params [String] :display_name
    #   The display name for the conversation.
    #
    # @option params [String] :image_url
    #   A link to an image for conversations' and users' avatars.
    #
    # @option params [Hash] :numbers
    #   - **:sms** (String) phone number used for sms channel
    #   - **:pstn** (String) phone number used for pstn channel
    #
    # @option params [Hash] :properties
    #   - **:ttl** (Integer) After how many seconds an empty conversation is deleted
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#replaceConversation
    #
    sig { params(
      id: String,
      params: T::Hash[Symbol, T.untyped]
    ).returns(Vonage::Response) }
    def update(id, params)
      request('/beta/conversations/' + id, params: params, type: Put)
    end

    # Delete a conversation.
    #
    # @example
    #   response = client.conversations.delete(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteConversation
    #
    sig { params(id: String).returns(Vonage::Response) }
    def delete(id)
      request('/beta/conversations/' + id, type: Delete)
    end

    # Record a conversation.
    #
    # @example
    #   response = client.conversations.record(id, action: 'start')
    #
    # @option params [String] :action
    #   Recording action. Must be one of `start` or `stop`.
    #
    # @option params [String] :event_url
    #   The webhook endpoint where recording progress events are sent to.
    #
    # @option params [String] :event_method
    #   The HTTP method used to send event information to **:event_url**.
    #
    # @option params [String] :split
    #   Record the sent and received audio in separate channels of a stereo recording.
    #
    # @option params [String] :format
    #   Record the conversation in a specific format.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#recordConversation
    #
    sig { params(
      id: String,
      params: T::Hash[Symbol, T.untyped]
    ).returns(Vonage::Response) }
    def record(id, params)
      request('/v1/conversations/' + id + '/record', params: params, type: Put)
    end

    # @return [Events]
    #
    sig { returns(T.nilable(Vonage::Conversations::Events)) }
    def events
      @events = T.let(@events, T.nilable(Vonage::Conversations::Events))
      @config = T.let(@config, T.nilable(Vonage::Config))
      @events ||= Events.new(@config)
    end

    # @return [Legs]
    #
    sig { returns(T.nilable(Vonage::Conversations::Legs)) }
    def legs
      @legs = T.let(@legs, T.nilable(Vonage::Conversations::Legs))
      @legs ||= Legs.new(@config)
    end

    # @return [Members]
    #
    sig { returns(T.nilable(Vonage::Conversations::Members)) }
    def members
      @members = T.let(@members, T.nilable(Vonage::Conversations::Members))
      @members ||= Members.new(@config)
    end

    # @return [Users]
    #
    sig { returns(T.nilable(Vonage::Conversations::Users)) }
    def users
      @users = T.let(@users, T.nilable(Vonage::Conversations::Users))
      @users ||= Users.new(@config)
    end
  end
end
