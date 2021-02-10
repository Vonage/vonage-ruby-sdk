# typed: strict
# frozen_string_literal: true
require 'json'

module Vonage
  module JSON
    extend T::Sig

    sig { params(http_request: T.any(Net::HTTP::Put, Net::HTTP::Post), params: T::Hash[Symbol, T.untyped]).void }
    def self.update(http_request, params)
      http_request['Content-Type'] = 'application/json'
      http_request.body = ::JSON.generate(params)
    end
  end

  private_constant :JSON
end
