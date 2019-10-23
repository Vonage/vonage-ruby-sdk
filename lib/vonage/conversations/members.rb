# typed: true
# frozen_string_literal: true

module Vonage
  class Conversations::Members < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Create a member.
    #
    # @option params [String] :action
    #   Invite or join a member to a conversation.
    #   Must be one of: `invite` or `join`.
    #
    # @option params [required, String] :user_id
    #   User ID. Must supply either :user_id or :user_name.
    #
    # @option params [required, String] :user_name
    #   The name of the user. Must supply either :user_id or :user_name.
    #
    # @option params [String] :member_id
    #   Member ID.
    #
    # @option params [required, Hash] :channel
    #   A user who joins a conversation as a member can have one channel per membership type.
    #
    # @option params ['join', 'invite'] :action
    #   The action to take when adding a user to the conversation. 
    #
    # @param [String] conversation_id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#createMember
    #
    def create(conversation_id, params)
      request('/v0.1/conversations/' + conversation_id + '/members', params: params, type: Post)
    end

    # List members.
    #
    # @option params (Integer) :page_size
    #   The number of results returned per page.
    #
    # @option params ['asc', 'desc'] :order
    #   Show the most (desc) / least (asc) recently created entries first.
    #
    # @param [String] conversation_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getMembers
    #
    def list(conversation_id, params = nil)
      request('/v0.1/conversations/' + conversation_id + '/members', params: params)
    end

    # Retrieve a member.
    #
    # @param [String] conversation_id
    # @param [String] member_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getMember
    #
    def get(conversation_id, member_id)
      request('/v0.1/conversations/' + conversation_id + '/members/' + member_id)
    end

    # Update a member.
    #
    # @option params ['join'] :state
    #   The state that the member is in for this conversation.
    #
    # @option params [Hash] :channel
    #   - **:type** (String) A user who joins a conversation as a member can have one channel per membership type.
    #
    # @param [String] conversation_id
    # @param [String] member_id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#updateMember
    #
    def update(conversation_id, member_id, params)
      request('/v0.1/conversations/' + conversation_id + '/members/' + member_id, params: params, type: Put)
    end

    # Delete a member.
    #
    # @param [String] conversation_id
    # @param [String] member_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteMember
    #
    def delete(conversation_id, member_id)
      request('/v0.1/conversations/' + conversation_id + '/members/' + member_id, type: Delete)
    end
  end
end
