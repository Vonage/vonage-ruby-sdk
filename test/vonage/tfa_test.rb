# typed: false
require_relative './test'

class Vonage::TFATest < Vonage::Test
  def tfa
    Vonage::TFA.new(config)
  end

  def uri
    'https://rest.nexmo.com/sc/us/2fa/json'
  end

  def test_send_method
    params = {to: msisdn, pin: '12345'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, tfa.send(params)
  end

  def test_mapping_underscored_keys_to_hyphenated_string_keys
    params = {'client-ref' => '12345'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, tfa.send(client_ref: '12345')
  end
end
