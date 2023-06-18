# typed: false
require_relative './test'

class Vonage::SubaccountsTest < Vonage::Test
  def subaccounts
    Vonage::Subaccounts.new(config)
  end

  def accounts_uri
    "https://rest.nexmo.com/accounts/#{api_key}"
  end

  def subaccounts_uri
    "#{accounts_uri}/subaccounts"
  end

  def subaccount_api_key
    'vonage-subaccount-api-key'
  end

  def test_list_method
    stub_request(:get, subaccounts_uri).to_return(subaccounts_list_response)

    subaccounts_list = subaccounts.list

    assert_kind_of Vonage::Subaccounts::ListResponse, subaccounts_list
    assert_kind_of Vonage::Entity, subaccounts_list.primary_account

    subaccounts_list.each { |subaccount| assert_kind_of Vonage::Entity, subaccount }
  end

  def test_find_method
    stub_request(:get, "#{subaccounts_uri}/#{subaccount_api_key}").to_return(response)

    assert_kind_of Vonage::Response, subaccounts.find(subaccount_key: subaccount_api_key)
  end

  def test_find_method_without_subaccount_key
    assert_raises ArgumentError do
      subaccounts.find
    end
  end

  def test_create_method
    stub_request(:post, subaccounts_uri).with(request(body: { name: "Foo" }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.create(name: "Foo")
  end

  def test_create_method_with_optional_params
    stub_request(:post, subaccounts_uri).with(request(body: { name: "Foo", secret: "Password123", use_primary_account_balance: false }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.create(name: "Foo", secret: "Password123", use_primary_account_balance: false)
  end

  def test_create_method_without_name
    assert_raises ArgumentError do
      subaccounts.create
    end
  end

  def test_update_method
    stub_request(:patch, "#{subaccounts_uri}/#{subaccount_api_key}").with(request(body: { name: "Bar" }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.update(subaccount_key: subaccount_api_key, name: "Bar")
  end

  def test_update_method_without_subaccount_key
    assert_raises ArgumentError do
      subaccounts.update
    end
  end

  def test_list_credit_transfers_method
    stub_request(:get, "#{accounts_uri}/credit-transfers").with(request(auth: basic_authorization)).to_return(credit_transfers_list_response)

    credit_transfers_list = subaccounts.list_credit_transfers

    assert_kind_of Vonage::Subaccounts::CreditTransfers::ListResponse, credit_transfers_list
    credit_transfers_list.each { |credit_transfer| assert_kind_of Vonage::Entity, credit_transfer }
  end

  def test_list_credit_transfers_method_with_optional_params
    query = "?subaccount=abc123"
    stub_request(:get, "#{accounts_uri}/credit-transfers#{query}").with(request(auth: basic_authorization)).to_return(credit_transfers_list_response_filtered)

    credit_transfers_list = subaccounts.list_credit_transfers(subaccount: 'abc123')

    assert_kind_of Vonage::Subaccounts::CreditTransfers::ListResponse, credit_transfers_list
    credit_transfers_list.each { |credit_transfer| assert_kind_of Vonage::Entity, credit_transfer }
  end

  def test_transfer_credit_method
    stub_request(:post, "#{accounts_uri}/credit-transfers").with(request(body: { from: "abc123", to: "def456", amount: "123.45" }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.transfer_credit(from: "abc123", to: "def456", amount: "123.45")
  end

  def test_transfer_credit_method_with_optional_params
    stub_request(:post, "#{accounts_uri}/credit-transfers").with(request(body: { from: "abc123", to: "def456", amount: "123.45", reference: "Foo" }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.transfer_credit(from: "abc123", to: "def456", amount: "123.45", reference: "Foo" )
  end

  def test_transfer_credit_method_without_from
    assert_raises ArgumentError do
      subaccounts.transfer_credit(to: "def456", amount: "123.45")
    end
  end

  def test_transfer_credit_method_without_to
    assert_raises ArgumentError do
      subaccounts.transfer_credit(from: "abc123", amount: "123.45")
    end
  end

  def test_transfer_credit_method_without_amount
    assert_raises ArgumentError do
      subaccounts.transfer_credit(from: "abc123", to: "def456")
    end
  end

  def test_list_balance_transfers_method
    stub_request(:get, "#{accounts_uri}/balance-transfers").with(request(auth: basic_authorization)).to_return(balance_transfers_list_response)

    balance_transfers_list = subaccounts.list_balance_transfers

    assert_kind_of Vonage::Subaccounts::BalanceTransfers::ListResponse, balance_transfers_list
    balance_transfers_list.each { |balance_transfer| assert_kind_of Vonage::Entity, balance_transfer }
  end

  def test_list_balance_transfers_method_with_optional_params
    query = "?subaccount=abc123"
    stub_request(:get, "#{accounts_uri}/balance-transfers#{query}").with(request(auth: basic_authorization)).to_return(balance_transfers_list_response_filtered)

    balance_transfers_list = subaccounts.list_balance_transfers(subaccount: 'abc123')

    assert_kind_of Vonage::Subaccounts::BalanceTransfers::ListResponse, balance_transfers_list
    balance_transfers_list.each { |balance_transfer| assert_kind_of Vonage::Entity, balance_transfer }
  end

  def test_transfer_balance_method
    stub_request(:post, "#{accounts_uri}/balance-transfers").with(request(body: { from: "abc123", to: "def456", amount: "123.45" }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.transfer_balance(from: "abc123", to: "def456", amount: "123.45")
  end

  def test_transfer_balance_method_with_optional_params
    stub_request(:post, "#{accounts_uri}/balance-transfers").with(request(body: { from: "abc123", to: "def456", amount: "123.45", reference: "Foo" }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.transfer_balance(from: "abc123", to: "def456", amount: "123.45", reference: "Foo" )
  end

  def test_transfer_balance_method_without_from
    assert_raises ArgumentError do
      subaccounts.transfer_balance(to: "def456", amount: "123.45")
    end
  end

  def test_transfer_balance_method_without_to
    assert_raises ArgumentError do
      subaccounts.transfer_balance(from: "abc123", amount: "123.45")
    end
  end

  def test_transfer_balance_method_without_amount
    assert_raises ArgumentError do
      subaccounts.transfer_balance(from: "abc123", to: "def456")
    end
  end

  def test_transfer_number_method
    stub_request(:post, "#{accounts_uri}/transfer-number").with(request(body: { from: "abc123", to: "def456", number: 23507703696 }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.transfer_number(from: "abc123", to: "def456", number: 23507703696)
  end

  def test_transfer_number_method_with_optional_params
    stub_request(:post, "#{accounts_uri}/transfer-number").with(request(body: { from: "abc123", to: "def456", number: 23507703696, country: 'GB' }, auth: basic_authorization)).to_return(response)

    assert_kind_of Vonage::Response, subaccounts.transfer_number(from: "abc123", to: "def456", number: 23507703696, country: 'GB' )
  end

  def test_transfer_number_method_without_from
    assert_raises ArgumentError do
      subaccounts.transfer_number(to: "def456", number: 23507703696)
    end
  end

  def test_transfer_number_method_without_to
    assert_raises ArgumentError do
      subaccounts.transfer_number(from: "abc123", number: 23507703696)
    end
  end

  def test_transfer_number_method_without_amount
    assert_raises ArgumentError do
      subaccounts.transfer_number(from: "abc123", to: "def456")
    end
  end

  def subaccounts_list_response
    {
      headers: response_headers,
      body: '{
        "_embedded": {
          "primary_account": {
              "api_key": "bbe6222f",
              "name": "Subaccount department A",
              "primary_account_api_key": "acc6111f",
              "use_primary_account_balance": true,
              "created_at": "2018-03-02T16:34:49Z",
              "suspended": false,
              "balance": 100.25,
              "credit_limit": -100.25
          },
          "subaccounts": [
              {
                "api_key": "bbe6222f",
                "name": "Subaccount department A",
                "primary_account_api_key": "acc6111f",
                "use_primary_account_balance": true,
                "created_at": "2018-03-02T16:34:49Z",
                "suspended": false,
                "balance": 100.25,
                "credit_limit": -100.25
              }
            ]
          }
        }'
        }
  end

  def credit_transfers_list_response
    {
      headers: response_headers,
      body: '{
        "_embedded": {
          "credit-transfers": [
              {
                "credit_transfer_id": "07b5-46e1-a527-85530e625800",
                "amount": 123.45,
                "from": "7c9738e6",
                "to": "abc123",
                "created_at": "2019-03-02T16:34:49Z"
              },
              {
                "credit_transfer_id": "07b5-46e1-a527-85530e625800",
                "amount": 100.99,
                "from": "def456",
                "to": "ad6dc56f",
                "created_at": "2019-03-02T16:34:49Z"
              }
            ]
          }
        }'
    }
  end

  def credit_transfers_list_response_filtered
    {
     headers: response_headers,
      body: '{
        "_embedded": {
          "credit-transfers": [
              {
                "credit_transfer_id": "07b5-46e1-a527-85530e625800",
                "amount": 123.45,
                "from": "7c9738e6",
                "to": "abc123",
                "created_at": "2019-03-02T16:34:49Z"
              }
            ]
          }
        }'
    }
  end

  def balance_transfers_list_response
    {
      headers: response_headers,
      body: '{
        "_embedded": {
          "balance_transfers": [
              {
                "balance_transfer_id": "07b5-46e1-a527-85530e625800",
                "amount": 123.45,
                "from": "7c9738e6",
                "to": "abc123",
                "created_at": "2019-03-02T16:34:49Z"
              },
              {
                "balance_transfer_id": "07b5-46e1-a527-85530e625800",
                "amount": 123.45,
                "from": "7c9738e6",
                "to": "def456",
                "created_at": "2019-03-02T16:34:49Z"
              }
            ]
          }
        }'
    }
  end

  def balance_transfers_list_response_filtered
    {
      headers: response_headers,
      body: '{
        "_embedded": {
          "balance_transfers": [
              {
                "balance_transfer_id": "07b5-46e1-a527-85530e625800",
                "amount": 123.45,
                "from": "7c9738e6",
                "to": "abc123",
                "created_at": "2019-03-02T16:34:49Z"
              }
            ]
           }
          }'
    }
  end
end
