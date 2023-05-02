# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Events < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    def list(**params)
      path = "/v0.1/bulk/events"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end
  end
end
