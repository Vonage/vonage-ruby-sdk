# frozen_string_literal: true

module Nexmo
  class ConversationEvents < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    def create(conversation_id, params)
      request('/beta/conversations/' + conversation_id + '/events', params: params, type: Post)
    end

    def list(conversation_id)
      request('/beta/conversations/' + conversation_id + '/events')
    end

    def get(conversation_id, event_id)
      request('/beta/conversations/' + conversation_id + '/events/' + event_id.to_s)
    end

    def delete(conversation_id, event_id)
      request('/beta/conversations/' + conversation_id + '/events/' + event_id.to_s, type: Delete)
    end
  end
end
