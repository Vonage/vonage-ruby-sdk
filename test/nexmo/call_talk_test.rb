require_relative './test'

class NexmoCallTalkTest < Nexmo::Test
  def talk
    Nexmo::CallTalk.new(client)
  end

  def call_uuid
    'xx-xx-xx-xx'
  end

  def uri
    'https://api.nexmo.com/v1/calls/' + call_uuid + '/talk'
  end

  def test_start_method
    headers = {
      'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/,
      'Content-Type' => 'application/json'
    }

    params = {text: 'Hello'}

    request = stub_request(:put, uri).with(headers: headers, body: params).to_return(response)

    assert_equal response_object, talk.start(call_uuid, params)
    assert_requested request
  end

  def test_stop_method
    headers = {
      'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/
    }

    request = stub_request(:delete, uri).with(headers: headers).to_return(response)

    assert_equal response_object, talk.stop(call_uuid)
    assert_requested request
  end
end
