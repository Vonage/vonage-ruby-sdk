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
    # @option params [Hash] :properties
    #   - **:custom_data** [Hash] Any custom data that you'd like to attach to the conversation.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#createUser
    #
    def create(params)
      request('/v0.1/users', params: params, type: Post)
    end

    # List users.
    #
    # @option params (Integer) :page_size
    #   The number of results returned per page.
    #
    # @option params ['asc', 'desc'] :order
    #   Show the most (desc) / least (asc) recently created entries first.   
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getUsers
    #
    def list(params = nil)
      request('/v0.1/users', params: params)
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
      request('/v0.1/users/' + id)
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
    # @option params [Hash] :properties
    #   - **:custom_data** (Hash) Any custom data that you'd like to attach to the conversation.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#updateUser
    #
    def update(id, params)
      request('/v0.1/users/' + id, params: params, type: Put)
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
      request('/v0.1/users/' + id, type: Delete)
    end
  end
end
