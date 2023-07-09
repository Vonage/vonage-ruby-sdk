# typed: strict
# frozen_string_literal: true

module Vonage
  class Subaccounts < Namespace
    self.authentication = Basic

    self.request_body = JSON

    # Retrieve list of subaccounts.
    #
    # @example
    #   response = client.subaccounts.list
    #
    # @see https://developer.vonage.com/en/api/subaccounts#retrieveSubaccountsList
    #
    def list
      request("/accounts/#{@config.api_key}/subaccounts", response_class: ListResponse)
    end

    # Retrieve a subaccount.
    #
    # @example
    #   response = client.subaccounts.find(subaccount_key: 'abc123')
    #
    # @option params [required, String] :subaccount_key
    #   The API key for the subaccount you want to retrieve
    #
    # @see https://developer.vonage.com/en/api/subaccounts#retrieveSubaccount
    #
    def find(subaccount_key:)
      request("/accounts/#{@config.api_key}/subaccounts/#{subaccount_key}")
    end

    # Create a subaccount.
    #
    # @example
    #   response = client.subaccounts.create(name: 'Foo')
    #
    # @option params [required, String] :name
    #   The name of the subaccount
    #
    # @option params [optional, String] :secret
    #   An account secret for use by the subaccount. Can be used in combination with your API key to authenticate your API requests.
    #   Requirements:
    #     - 8 characters and no more than 25
    #     - 1 lower-case letter
    #     - 1 capital letter
    #     - 1 digit
    #     - must be unique
    #
    # @option params [optional, Boolean] :use_primary_account_balance
    #   Whether the subaccount uses the primary account balance (true, the default) or has its own balance (false).
    #   Once set to `false` cannot be changed back to `true`
    #
    # @see https://developer.vonage.com/en/api/subaccounts#createSubAccount
    #
    def create(name:, **params)
      request("/accounts/#{@config.api_key}/subaccounts", params: params.merge(name: name), type: Post)
    end

    # Modify a subaccount.
    #
    # @example
    #   response = client.subaccounts.update(name: 'Bar')
    #
    # @option params [required, String] :subaccount_key
    #   The API key for the subaccount you want to modify
    #
    # @option params [optional, String] :name
    #   The name of the subaccount
    #
    # @option params [optional, Boolean] :use_primary_account_balance
    #   Whether the subaccount uses the primary account balance (true, the default) or has its own balance (false).
    #   Once set to `false` cannot be changed back to `true`
    #
    # @option params [optional, String] :suspended
    #   Whether the subaccount is suspended (true) or not (false, the default)
    #
    # @see https://developer.vonage.com/en/api/subaccounts#modifySubaccount
    #
    def update(subaccount_key:, **params)
      request("/accounts/#{@config.api_key}/subaccounts/#{subaccount_key}", params: params, type: Patch)
    end

    # Retrieve list of credit transfers.
    #
    # @example
    #   response = client.subaccounts.list_credit_transfers(start_date: "2023-06-15T15:53:50Z")
    #
    # @option params [optional, String] :start_date
    #   The ISO format datetime from which to list transfers. Example: 2019-03-02T16:34:49Z.
    #   Defaults to "1970-01-01T00:00:00Z" if omitted
    #
    # @option params [optional, String] :end_date
    #   The ISO format datetime to which to list transfers. Example: 2019-03-02T16:34:49Z.
    #   If absent then all transfers until now is returned.
    #
    # @option params [optional, String] :subaccount
    #   Subaccount to filter by.
    #
    # @see https://developer.vonage.com/en/api/subaccounts#retrieveCreditTransfers
    #
    def list_credit_transfers(start_date: "1970-01-01T00:00:00Z", **params)
      path = "/accounts/#{@config.api_key}/credit-transfers?#{Params.encode(params.merge(start_date: start_date))}"

      request(path, response_class: CreditTransfers::ListResponse)
    end

    # Transfer credit.
    #
    # @example
    #   response = client.subaccounts.transfer_credit(from: 'abc123', to: 'def456', amount: 10.00)
    #
    # @option params [required, String] :from
    #   The API key of the account or subaccount to transfer credit from.
    #
    # @option params [required, String] :to
    #   The API key of the account or subaccount to transfer credit to.
    #
    # @option params [required, Number] :amount
    #   The amount to transfer
    #
    # @option params [optional, String] :reference
    #   A reference for the transfer.
    #
    # @see https://developer.vonage.com/en/api/subaccounts#transferCredit
    #
    def transfer_credit(from:, to:, amount:, **params)
      request("/accounts/#{@config.api_key}/credit-transfers", params: params.merge(from: from, to: to, amount: amount), type: Post)
    end

    # Retrieve list of balance transfers.
    #
    # @example
    #   response = client.subaccounts.list_balance_transfers(start_date: "2023-06-15T15:53:50Z")
    #
    # @option params [optional, String] :start_date
    #   The ISO format datetime from which to list transfers. Example: 2019-03-02T16:34:49Z.
    #   Defaults to "1970-01-01T00:00:00Z" if omitted
    #
    # @option params [optional, String] :end_date
    #   The ISO format datetime to which to list transfers. Example: 2019-03-02T16:34:49Z.
    #   If absent then all transfers until now is returned.
    #
    # @option params [optional, String] :subaccount
    #   Subaccount to filter by.
    #
    # @see https://developer.vonage.com/en/api/subaccounts#retrieveBalanceTransfers
    #
    def list_balance_transfers(start_date: "1970-01-01T00:00:00Z", **params)
      path = "/accounts/#{@config.api_key}/balance-transfers?#{Params.encode(params.merge(start_date: start_date))}"

      request(path, response_class: BalanceTransfers::ListResponse)
    end

    # Transfer balance.
    #
    # @example
    #   response = client.subaccounts.transfer_balance(from: 'abc123', to: 'def456', amount: 10.00)
    #
    # @option params [required, String] :from
    #   The API key of the account or subaccount to transfer balance from.
    #
    # @option params [required, String] :to
    #   The API key of the account or subaccount to transfer balance to.
    #
    # @option params [required, Number] :amount
    #   The amount to transfer
    #
    # @option params [optional, String] :reference
    #   A reference for the transfer.
    #
    # @see https://developer.vonage.com/en/api/subaccounts#transferBalance
    #
    def transfer_balance(from:, to:, amount:, **params)
      request("/accounts/#{@config.api_key}/balance-transfers", params: params.merge(from: from, to: to, amount: amount), type: Post)
    end

    # Transfer number.
    #
    # @example
    #   response = client.subaccounts.transfer_number(from: 'abc123', to: 'def456', number: 447900000000, country: 'GB')
    #
    # @option params [required, String] :from
    #   The API key of the account or subaccount to transfer the number from.
    #
    # @option params [required, String] :to
    #   The API key of the account or subaccount to transfer the number to.
    #
    # @option params [required, Number] :number
    #   The number to transfer
    #
    # @option params [required, String] :country
    #   An ISO-3166-1 alpha 2 code representing the country for the number, e.g. GB.
    #
    # @see https://developer.vonage.com/en/api/subaccounts#transferNumber
    #
    def transfer_number(from:, to:, number:, country:)
      request("/accounts/#{@config.api_key}/transfer-number", params: {from: from, to: to, number: number, country: country}, type: Post)
    end
  end
end
