# typed: true
# frozen_string_literal: true

module Vonage
  class Conversations::Users < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Create a user.
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
      request('/beta/users', params: params, type: Post)
    end

    # List users.
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getUsers
    #
    def list
      request('/beta/users')
    end

    # Retrieve a user.
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getUser
    #
    def get(id)
      request('/beta/users/' + id)
    end

    # Update a user.
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
      request('/beta/users/' + id, params: params, type: Put)
    end

    # Delete a user.
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteUser
    #
    def delete(id)
      request('/beta/users/' + id, type: Delete)
    end
  end
end
