require_relative './test'

class NexmoCallStreamTest < Nexmo::Test
  def stream
    Nexmo::CallStream.new(client)
  end

  def call_uuid
    'xx-xx-xx-xx'
  end

  def uri
    'https://api.nexmo.com/v1/calls/' + call_uuid + '/stream'
  end

  def test_start_method
    headers = {
      'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/,
      'Content-Type' => 'application/json'
    }

    params = {stream_url: 'https://example.com/audio.mp3'}

    request = stub_request(:put, uri).with(headers: headers, body: params).to_return(response)

    assert_equal response_object, stream.start(call_uuid, params)
    assert_requested request
  end

  def test_stop_method
    headers = {
      'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/
    }

    request = stub_request(:delete, uri).with(headers: headers).to_return(response)

    assert_equal response_object, stream.stop(call_uuid)
    assert_requested request
  end
end
