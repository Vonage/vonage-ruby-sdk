# typed: strict
# frozen_string_literal: true

module Vonage
  class Users < Namespace
    extend T::Sig
    self.authentication = BearerToken

    self.request_body = JSON

    def list(**params)
      request('/v1/users', params: params, response_class: ListResponse)
    end

    def find(id:)
      request("/v1/users/#{id}")
    end

    def create(**params)
      request('/v1/users', params: params, type: Post)
    end

    def update(id:, **params)
      request("/v1/users/#{id}", params: params.merge(id: id), type: Patch)
    end

    def delete(id:)
      request("/v1/users/#{id}", type: Delete)
    end
  end
end
