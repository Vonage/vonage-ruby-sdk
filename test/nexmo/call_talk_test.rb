require_relative './test'

class NexmoCallTalkTest < Nexmo::Test
  def talk
    Nexmo::CallTalk.new(config)
  end

  def uri
    'https://api.nexmo.com/v1/calls/' + call_uuid + '/talk'
  end

  def test_start_method
    params = {text: 'Hello'}

    request_stub = stub_request(:put, uri).with(request(body: params)).to_return(response)

    assert_equal response_object, talk.start(call_uuid, params)
    assert_requested request_stub
  end

  def test_stop_method
    request_stub = stub_request(:delete, uri).with(request).to_return(response)

    assert_equal response_object, talk.stop(call_uuid)
    assert_requested request_stub
  end
end
