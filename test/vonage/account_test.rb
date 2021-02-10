# typed: false
require_relative './test'

class Vonage::AccountTest < Vonage::Test
  def account
    Vonage::Account.new(config)
  end

  def test_balance_method
    uri = 'https://rest.nexmo.com/account/get-balance'

    stub_request(:get, uri).with(query: api_key_and_secret).to_return(response)

    assert_kind_of Vonage::Response, account.balance
  end

  def test_update_method
    uri = 'https://rest.nexmo.com/account/settings'

    callback_url = 'https://example.com/callback'

    params = {'moCallBackUrl' => callback_url}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, account.update(mo_call_back_url: callback_url)
  end

  def test_topup_method
    uri = 'https://rest.nexmo.com/account/top-up'

    params = {trx: '00X123456Y7890123Z'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, account.topup(params)
  end
end
