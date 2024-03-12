# typed: true
# frozen_string_literal: true

module Vonage
  class Conversation::Member < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # List members of a conversation
    #
    # @example
    #   response = client.conversation.member.list(conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a')
    #
    # @param [required, String] :conversation_id The conversation_id of the conversation to list members for
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
    # @return [Conversation::Member::ListResponse]
    #
    # @see https://developer.vonage.com/en/api/conversation#getMembers
    #
    def list(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}/members", params: params, response_class: ListResponse)
    end

    # Create a member.
    #
    # @example
    #   response = client.conversation.member.create(
    #     conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a',
    #     user: {
    #       id: 'USR-82e028d9-5201-4f1e-8188-604b2d3471ec'
    #     }
    #   )
    #
    # @param [required, String] :conversation_id The conversation_id of the conversation for which to create the member
    #
    # @param [String] :state Must be one of ['invited', 'joined']
    #
    # @param [Hash] :user (Either :id or :name is required)
    #   - @option user [String] :id The user_id of the user to add to the conversation
    #   - @option user [String] :name The name of the user to add to the conversation
    #
    # @param [Hash] :channel
    #   - @option channel [required, String] :type The type of channel
    #   - @option channel [Hash] :from
    #     - @option from [String] :type
    #     - @option from [String] :number
    #     - @option from [String] :id
    #   - @option channel [Hash] :to
    #     - @option from [String] :type 
    #     - @option from [String] :user
    #     - @option from [String] :number
    #     - @option from [String] :id
    #
    # @param [Hash] :media
    #   - @option media [Boolean] :audio
    #   - @option media [Hash] :audio_settings
    #     - @option audio_settings [Boolean] :enabled
    #     - @option audio_settings [Boolean] :earmuffed
    #     - @option audio_settings [Boolean] :muted
    #
    # @param [String] :knocking_id
    #
    # @param [String] :member_id_inviting
    #
    # @param [String] :from
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#createMember
    #
    def create(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}/members", params: params, type: Post)
    end

    # Retrieve a member
    #
    # @example
    #   response = client.conversation.member.find(
    #     conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a',
    #     member_id: 'MEM-63f61863-4a51-4f6b-86e1-46edebio0391'
    #   )  
    #
    # @param [required, String] :conversation_id
    #
    # @param [required, String] :member_id
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#getMember
    #
    def find(conversation_id:, member_id:)   
      request("/v1/conversations/#{conversation_id}/members/#{member_id}", response_class: Vonage::Response)
    end

    # Update a member
    #
    # @example
    #   response = client.conversation.member.update(
    #     conversation_id: 'CON-d66d47de-5bcb-4300-94f0-0c9d4b948e9a',
    #     member_id: 'MEM-63f61863-4a51-4f6b-86e1-46edebio0391',
    #     state: 'left'
    #   )  
    #
    # @param [required, String] :conversation_id
    #
    # @param [required, String] :member_id
    #
    # @param [String] :state Must be one of ['joined', 'left']
    #
    # @param [String] :from
    #
    # @param [Hash] :reason
    #  - @option reason [String] :code
    #  - @option reason [String] :text
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/conversation#updateMember
    #
    def update(conversation_id:, member_id:, **params)
      request("/v1/conversations/#{conversation_id}/members/#{member_id}", params: params, type: Patch)
    end
  end
end
