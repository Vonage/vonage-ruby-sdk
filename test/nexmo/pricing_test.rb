require_relative './test'

class NexmoPricingTest < Nexmo::Test
  def type
    'sms'
  end

  def country
    'GB'
  end

  def prefix
    '44'
  end

  def pricing
    Nexmo::Pricing.new(config, type: type)
  end

  def test_get_method
    uri = 'https://rest.nexmo.com/account/get-pricing/outbound/sms'

    params = {country: country}

    request_stub = stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, pricing.get(country)
    assert_requested request_stub
  end

  def test_list_method
    uri = 'https://rest.nexmo.com/account/get-full-pricing/outbound/sms'

    request_stub = stub_request(:get, uri).with(query: api_key_and_secret).to_return(response)

    assert_equal response_object, pricing.list
    assert_requested request_stub
  end

  def test_prefix_method
    uri = 'https://rest.nexmo.com/account/get-prefix-pricing/outbound/sms'

    params = {prefix: prefix}

    request_stub = stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, pricing.prefix(prefix)
    assert_requested request_stub
  end
end
