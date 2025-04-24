# typed: strict
# frozen_string_literal: true

module Vonage
  class Reports < Namespace
    extend T::Sig

    self.authentication = Basic

    self.request_body = JSON

    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def get_records(params = {})
      request('/v2/reports/records', params: params)
    end
  end
end
