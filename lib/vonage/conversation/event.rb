# typed: true
# frozen_string_literal: true

module Vonage
  class Conversation::Event < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    def list(conversation_id:, **params)  
      request("/v1/conversations/#{conversation_id}/events", params: params, response_class: ListResponse)
    end

    def create(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}/events", params: params, type: Post)
    end

    def find(conversation_id:, event_id:)
      request("/v1/conversations/#{conversation_id}/events/#{event_id}")
    end

    def delete(conversation_id:, event_id:)
      request("/v1/conversations/#{conversation_id}/events/#{event_id}", type: Delete)
    end
  end
end
