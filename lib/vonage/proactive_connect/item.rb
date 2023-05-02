# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Item < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_body = JSON

    def create(list_id:, data:)
      raise ArgumentError.new(":data must be a Hash") unless data.is_a? Hash
      request(
        "/v0.1/bulk/lists/#{list_id}/items",
        params: { data: data },
        type: Post
      )
    end

    def find(list_id:, item_id:)
      request("/v0.1/bulk/lists/#{list_id}/items/#{item_id}")
    end

    def update(list_id:, item_id:, data:)
      raise ArgumentError.new(":data must be a Hash") unless data.is_a? Hash
      request(
        "/v0.1/bulk/lists/#{list_id}/items/#{item_id}",
        params: { data: data },
        type: Put
      )
    end

    def delete(list_id:, item_id:)
      request(
        "/v0.1/bulk/lists/#{list_id}/items/#{item_id}",
        type: Delete
      )
    end
  end
end
