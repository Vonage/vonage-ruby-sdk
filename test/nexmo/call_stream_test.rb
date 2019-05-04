require_relative './test'

class NexmoCallStreamTest < Nexmo::Test
  def stream
    Nexmo::CallStream.new(client)
  end

  def uri
    'https://api.nexmo.com/v1/calls/' + call_uuid + '/stream'
  end

  def test_start_method
    headers = {'Authorization' => bearer_token, 'Content-Type' => 'application/json'}

    params = {stream_url: 'https://example.com/audio.mp3'}

    request_stub = stub_request(:put, uri).with(headers: headers, body: params).to_return(response)

    assert_equal response_object, stream.start(call_uuid, params)
    assert_requested request_stub
  end

  def test_stop_method
    headers = {'Authorization' => bearer_token}

    request_stub = stub_request(:delete, uri).with(headers: headers).to_return(response)

    assert_equal response_object, stream.stop(call_uuid)
    assert_requested request_stub
  end
end
