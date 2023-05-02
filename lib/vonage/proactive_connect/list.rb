# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::List < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_body = JSON

    def create(name:, **params)
      request(
        "/v0.1/bulk/lists",
        params: params.merge({ name: name }),
        type: Post
      )
    end

    def find(id:)
      request("/v0.1/bulk/lists/#{id}")
    end

    def update(id:, name:, **params)
      request(
        "/v0.1/bulk/lists/#{id}",
        params: params.merge({ name: name }),
        type: Put
      )
    end

    def delete(id:)
      request(
        "/v0.1/bulk/lists/#{id}",
        type: Delete
      )
    end

    def clear_items(id:)
      request(
        "/v0.1/bulk/lists/#{id}/clear",
        type: Post
      )
    end

    def fetch_and_replace_items(id:)
      request(
        "/v0.1/bulk/lists/#{id}/fetch",
        type: Post
      )
    end
  end
end
