# frozen_string_literal: true

module Nexmo
  class Redact < Namespace
    self.authentication = KeySecretQuery

    self.request_body = JSON

    def transaction(params)
      request('/v1/redact/transaction', params: params, type: Post)
    end
  end
end
