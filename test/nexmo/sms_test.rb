require_relative './test'

class NexmoSMSTest < Nexmo::Test
  def sms
    Nexmo::SMS.new(client)
  end

  def test_send_method
    uri = 'https://rest.nexmo.com/sms/json'

    params = {from: 'Ruby', to: '447700900000', text: 'Hello from Ruby!'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, sms.send(params)
    assert_requested request
  end
end
