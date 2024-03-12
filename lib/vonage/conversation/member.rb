# typed: true
# frozen_string_literal: true

module Vonage
  class Conversation::Member < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    def list(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}/members", params: params, response_class: ListResponse)
    end

    def create(conversation_id:, **params)
      request("/v1/conversations/#{conversation_id}/members", params: params, type: Post)
    end

    def find(conversation_id:, member_id:)   
      request("/v1/conversations/#{conversation_id}/members/#{member_id}", response_class: Vonage::Response)
    end

    def update(conversation_id:, member_id:, **params)
      request("/v1/conversations/#{conversation_id}/members/#{member_id}", params: params, type: Patch)
    end
  end
end
