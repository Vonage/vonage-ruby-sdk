require_relative './test'

class NexmoNumbersTest < Nexmo::Test
  def numbers
    Nexmo::Numbers.new(client)
  end

  def country
    'GB'
  end

  def msisdn
    '447700900000'
  end

  def test_list_method
    uri = 'https://rest.nexmo.com/account/numbers'

    params = {size: 25, pattern: '33'}

    request = stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, numbers.list(params)
    assert_requested request
  end

  def test_search_method
    uri = 'https://rest.nexmo.com/number/search'

    params = {size: 25, country: country}

    request = stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, numbers.search(params)
    assert_requested request
  end

  def test_buy_method
    uri = 'https://rest.nexmo.com/number/buy'

    params = {country: country, msisdn: msisdn}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, numbers.buy(params)
    assert_requested request
  end

  def test_cancel_method
    uri = 'https://rest.nexmo.com/number/cancel'

    params = {country: country, msisdn: msisdn}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, numbers.cancel(params)
    assert_requested request
  end

  def test_update_method
    uri = 'https://rest.nexmo.com/number/update'

    params = {country: country, msisdn: msisdn, moHttpUrl: 'https://example.com/callback'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, numbers.update(params)
    assert_requested request
  end
end
