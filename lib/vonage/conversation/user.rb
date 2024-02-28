# typed: true
# frozen_string_literal: true

module Vonage
  class Conversation::User < Namespace
    self.authentication = BearerToken

    def list_conversations(user_id:, **params)
      request("/v1/users/#{user_id}/conversations", params: params, response_class: ConversationsListResponse)
    end

    def list_sessions(user_id:, **params)
      request("/v1/users/#{user_id}/sessions", params: params, response_class: SessionsListResponse)
    end
  end
end
