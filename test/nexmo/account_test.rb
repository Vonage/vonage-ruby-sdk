require_relative './test'

class NexmoAccountTest < Nexmo::Test
  def account
    Nexmo::Account.new(client)
  end

  def test_balance_method
    uri = 'https://rest.nexmo.com/account/get-balance'

    request = stub_request(:get, uri).with(query: api_key_and_secret).to_return(response)

    assert_equal response_object, account.balance
    assert_requested request
  end

  def test_update_method
    uri = 'https://rest.nexmo.com/account/settings'

    params = {moCallBackUrl: 'https://example.com/callback'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, account.update(params)
    assert_requested request
  end

  def test_topup_method
    uri = 'https://rest.nexmo.com/account/top-up'

    params = {trx: '00X123456Y7890123Z'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, account.topup(params)
    assert_requested request
  end
end
