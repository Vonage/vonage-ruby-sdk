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
    #   User ID.
    #
    # @option params [String] :member_id
    #   Member ID.
    #
    # @option params [required, Hash] :channel
    #   A user who joins a conversation as a member can have one channel per membership type.
    #
    # @option params [Hash] :media
    #   Media Object.
    #
    # @option params [String] :knocking_id
    #   Knocker ID.
    #   A knocker is a pre-member of a conversation who does not exist yet.
    #
    # @option params [String] :member_id_inviting
    #   Member ID of the member that sends the invitation.
    #
    # @param [String] conversation_id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#createMember
    #
    def create(conversation_id, params)
      request('/beta/conversations/' + conversation_id + '/members', params: params, type: Post)
    end

    # List members.
    #
    # @param [String] conversation_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getMembers
    #
    def list(conversation_id)
      request('/beta/conversations/' + conversation_id + '/members')
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
      request('/beta/conversations/' + conversation_id + '/members/' + member_id)
    end

    # Update a member.
    #
    # @option params [String] :action
    #   Invite or join a member to a conversation.
    #
    # @option params [Hash] :channel
    #   A user who joins a conversation as a member can have one channel per membership type.
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
      request('/beta/conversations/' + conversation_id + '/members/' + member_id, params: params, type: Put)
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
      request('/beta/conversations/' + conversation_id + '/members/' + member_id, type: Delete)
    end
  end
end
