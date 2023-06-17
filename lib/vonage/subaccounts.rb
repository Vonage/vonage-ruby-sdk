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

    def update

    end

    def list_credit_transfers

    end

    def transfer_credit

    end

    def list_balance_transfers

    end

    def transfer_balance

    end

    def transfer_number

    end
  end
end
