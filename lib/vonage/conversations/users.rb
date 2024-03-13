# typed: true
# frozen_string_literal: true

module Vonage
  class Conversations::Users < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Create a user.
    #
    # @deprecated Please use {Vonage::Users#create} instead
    #
    # @option params [String] :name
    #   Unique name for a user.
    #
    # @option params [String] :display_name
    #   A string to be displayed as user name.
    #   It does not need to be unique.
    #
    # @option params [String] :image_url
    #   A link to an image for conversations' and users' avatars.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#createUser
    #
    def create(params)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Users#create` instead.')
      request('/beta/users', params: params, type: Post)
    end

    # List users.
    #
    # @deprecated Please use {Vonage::Users#list} instead
    #
    # @option params [Boolean] :auto_advance
    #   Set this to `false` to not auto-advance through all the pages in the record
    #   and collect all the data. The default is `true`.
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getUsers
    #
    def list(params = nil, auto_advance = true)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Users#list` instead.')
      request('/beta/users', params: params)
    end

    # Retrieve a user.
    #
    # @deprecated Please use {Vonage::Users#find} instead
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getUser
    #
    def get(id)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Users#find` instead.')
      request('/beta/users/' + id)
    end

    # Update a user.
    #
    # @deprecated Please use {Vonage::Users#update} instead
    #
    # @option params [String] :name
    #   Unique name for a user.
    #
    # @option params [String] :display_name
    #   A string to be displayed as user name.
    #   It does not need to be unique.
    #
    # @option params [String] :image_url
    #   A link to an image for conversations' and users' avatars.
    #
    # @option params [Hash] :channels
    #   A user who joins a conversation as a member can have one channel per membership type.
    #   Channels can be `app`, `phone`, `sip`, `websocket`, or `vbc`.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#updateUser
    #
    def update(id, params)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Users#update` instead.')
      request('/beta/users/' + id, params: params, type: Put)
    end

    # Delete a user.
    #
    # @deprecated Please use {Vonage::Users#delete} instead
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteUser
    #
    def delete(id)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Users#delete` instead.')
      request('/beta/users/' + id, type: Delete)
    end
  end
end
