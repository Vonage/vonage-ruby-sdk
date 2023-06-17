# typed: strict
# frozen_string_literal: true

module Vonage
  class Subaccounts < Namespace
    self.authentication = Basic

    self.host = :rest_host

    self.request_body = JSON

    def list

    end

    def find(subaccount_key:)
      request("/accounts/#{@config.api_key}/subaccounts/#{subaccount_key}")
    end

    def create(name:, **params)
      request("/accounts/#{@config.api_key}/subaccounts", params: params.merge(name: name), type: Post)
    end

    def update(subaccount_key:, **params)
      request("/accounts/#{@config.api_key}/subaccounts/#{subaccount_key}", params: params, type: Patch)
    end

    def list_credit_transfers

    end

    def transfer_credit(from:, to:, amount:, **params)
      request("/accounts/#{@config.api_key}/credit-transfers", params: params.merge(from: from, to: to, amount: amount), type: Post)
    end

    def list_balance_transfers

    end

    def transfer_balance(from:, to:, amount:, **params)
      request("/accounts/#{@config.api_key}/balance-transfers", params: params.merge(from: from, to: to, amount: amount), type: Post)
    end

    def transfer_number(from:, to:, number:, **params)
      request("/accounts/#{@config.api_key}/transfer-number", params: params.merge(from: from, to: to, number: number), type: Post)
    end
  end
end
