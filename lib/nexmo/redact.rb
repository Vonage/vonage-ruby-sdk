# frozen_string_literal: true

module Nexmo
  class Redact < Namespace
    self.authentication = KeySecretQuery

    def transaction(params)
      request('/v1/redact/transaction', params: params, type: Post)
    end

    private

    def json_body?
      true
    end
  end
end
