# frozen_string_literal: true

module Nexmo
  class ConversationMembers < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    def create(conversation_id, params)
      request('/beta/conversations/' + conversation_id + '/members', params: params, type: Post)
    end

    def list(conversation_id)
      request('/beta/conversations/' + conversation_id + '/members')
    end

    def get(conversation_id, member_id)
      request('/beta/conversations/' + conversation_id + '/members/' + member_id)
    end

    def update(conversation_id, member_id, params)
      request('/beta/conversations/' + conversation_id + '/members/' + member_id, params: params, type: Put)
    end

    def delete(conversation_id, member_id)
      request('/beta/conversations/' + conversation_id + '/members/' + member_id, type: Delete)
    end
  end
end
