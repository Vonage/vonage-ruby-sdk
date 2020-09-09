# typed: false
require_relative './test'

class Vonage::PricingTest < Vonage::Test
  def type
    'sms'
  end

  def pricing
    Vonage::Pricing.new(config, type: type)
  end

  def test_get_method
    uri = 'https://rest.nexmo.com/account/get-pricing/outbound/sms'

    params = {country: country}

    stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, pricing.get(country)
  end

  def test_list_method
    uri = 'https://rest.nexmo.com/account/get-full-pricing/outbound/sms'

    stub_request(:get, uri).with(query: api_key_and_secret).to_return(response)

    assert_kind_of Vonage::Response, pricing.list
  end

  def test_prefix_method
    uri = 'https://rest.nexmo.com/account/get-prefix-pricing/outbound/sms'

    params = {prefix: prefix}

    stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, pricing.prefix(prefix)
  end
end
