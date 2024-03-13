# typed: true
# frozen_string_literal: true

module Vonage
  class Conversations::Members < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Create a member.
    #
    # @deprecated Please use {Vonage::Conversation::Member#create} instead
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
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Member#create` instead.')
      request('/beta/conversations/' + conversation_id + '/members', params: params, type: Post)
    end

    # List members.
    #
    # @deprecated Please use {Vonage::Conversation::Member#list} instead
    #
    # @param [String] conversation_id
    #
    # @option params [Boolean] :auto_advance
    #   Set this to `false` to not auto-advance through all the pages in the record
    #   and collect all the data. The default is `true`.
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getMembers
    #
    def list(conversation_id, params = nil, auto_advance = true)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Member#list` instead.')
      request('/beta/conversations/' + conversation_id + '/members', params: params)
    end

    # Retrieve a member.
    #
    # @deprecated Please use {Vonage::Conversation::Member#find} instead
    #
    # @param [String] conversation_id
    # @param [String] member_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#getMember
    #
    def get(conversation_id, member_id)
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Member#find` instead.')
      request('/beta/conversations/' + conversation_id + '/members/' + member_id)
    end

    # Update a member.
    #
    # @deprecated Please use {Vonage::Conversation::Member#update} instead
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
      logger.info('This method is deprecated and will be removed in a future release. Please use `Vonage::Conversation::Member#update` instead.')
      request('/beta/conversations/' + conversation_id + '/members/' + member_id, params: params, type: Put)
    end

    # Delete a member.
    #
    # @deprecated
    #
    # @param [String] conversation_id
    # @param [String] member_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteMember
    #
    def delete(conversation_id, member_id)
      logger.info('This method is deprecated and will be removed in a future release.')
      request('/beta/conversations/' + conversation_id + '/members/' + member_id, type: Delete)
    end
  end
end
