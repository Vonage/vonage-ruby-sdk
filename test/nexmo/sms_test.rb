require_relative './test'

class NexmoSMSTest < Nexmo::Test
  def sms
    Nexmo::SMS.new(client)
  end

  def uri
    'https://rest.nexmo.com/sms/json'
  end

  def test_send_method
    params = {from: 'Ruby', to: '447700900000', text: 'Hello from Ruby!'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, sms.send(params)
    assert_requested request
  end

  def test_mapping_underscored_keys_to_hyphenated_string_keys
    params = {'status-report-req' => 1}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, sms.send(status_report_req: 1)
    assert_requested request
  end
end
