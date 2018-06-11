# frozen_string_literal: true

module Nexmo
  class Redact < Namespace
    def transaction(params)
      request('/v1/redact/transaction', params: params, type: Post)
    end

    private

    def authentication
      @authentication ||= KeySecretQuery.new(@client)
    end

    def json_body?
      true
    end
  end
end
