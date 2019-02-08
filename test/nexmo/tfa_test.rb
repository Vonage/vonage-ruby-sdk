require_relative './test'

class NexmoTFATest < Nexmo::Test
  def tfa
    Nexmo::TFA.new(client)
  end

  def test_send_method
    uri = 'https://rest.nexmo.com/sc/us/2fa/json'

    params = {to: msisdn, pin: '12345'}

    request = stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, tfa.send(params)
    assert_requested request
  end
end
