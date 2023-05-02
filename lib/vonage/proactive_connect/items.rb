# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Items < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    def list(list_id:, **params)
      path = "/v0.1/bulk/lists/#{list_id}/items"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end
  end
end
