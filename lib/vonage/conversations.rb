# typed: strict
# frozen_string_literal: true

module Vonage
  class Conversations < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    # Create a conversation.
    #
    # @deprecated Please use {Vonage::Conversation#create} instead
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
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#create` instead.')
      request('/beta/conversations', params: params, type: Post)
    end

    # List all conversations associated with your application.
    #
    # @deprecated Please use {Vonage::Conversation#list} instead
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
    # @option params [Boolean] :auto_advance
    #   Set this to `false` to not auto-advance through all the pages in the record
    #   and collect all the data. The default is `true`.
    # @param [Hash, nil] params
    #  
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#replaceConversation
    #
    sig { params(params: T.nilable(T::Hash[Symbol, T.untyped]), auto_advance: T::Boolean).returns(Vonage::Response) }
    def list(params = nil, auto_advance = true)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#list` instead.')
      if params && !params.key?(:auto_advance)
        params.merge!(auto_advance: true)
      end
      
      request('/beta/conversations', params: params)
    end

    # Retrieve a conversation.
    #
    # @deprecated Please use {Vonage::Conversation#find} instead
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
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#find` instead.')
      request('/beta/conversations/' + id)
    end
  
    # Update a conversation.
    #
    # @deprecated Please use {Vonage::Conversation#update} instead
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
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#update` instead.')
      request('/beta/conversations/' + id, params: params, type: Put)
    end

    # Delete a conversation.
    #
    # @deprecated Please use {Vonage::Conversation#delete} instead
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
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#delete` instead.')
      request('/beta/conversations/' + id, type: Delete)
    end

    # Record a conversation.
    #
    # @deprecated
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
      logger.info('This method is deprecated and will be removed in a future release.')
      request('/v1/conversations/' + id + '/record', params: params, type: Put)
    end

    # @return [Events]
    #
    # @deprecated Please use {Vonage::Conversation#event} instead
    #
    sig { returns(T.nilable(Vonage::Conversations::Events)) }
    def events
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#event` instead.')
      @events = T.let(@events, T.nilable(Vonage::Conversations::Events))
      @config = T.let(@config, T.nilable(Vonage::Config))
      @events ||= Events.new(@config)
    end

    # @return [Legs]
    #
    # @deprecated
    #
    sig { returns(T.nilable(Vonage::Conversations::Legs)) }
    def legs
      logger.info('This method is deprecated and will be removed in a future release.')
      @legs = T.let(@legs, T.nilable(Vonage::Conversations::Legs))
      @legs ||= Legs.new(@config)
    end

    # @return [Members]
    #
    # @deprecated Please use {Vonage::Conversation#member} instead
    #
    sig { returns(T.nilable(Vonage::Conversations::Members)) }
    def members
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#member` instead.')
      @members = T.let(@members, T.nilable(Vonage::Conversations::Members))
      @members ||= Members.new(@config)
    end

    # @return [Users]
    #
    # @deprecated Please use {Vonage::Conversation#user} instead
    #
    sig { returns(T.nilable(Vonage::Conversations::Users)) }
    def users
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation#user` instead.')
      @users = T.let(@users, T.nilable(Vonage::Conversations::Users))
      @users ||= Users.new(@config)
    end
  end
end
