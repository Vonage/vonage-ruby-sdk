require_relative './test'

class NexmoCallStreamTest < Nexmo::Test
  def stream
    Nexmo::CallStream.new(config)
  end

  def uri
    'https://api.nexmo.com/v1/calls/' + call_uuid + '/stream'
  end

  def test_start_method
    params = {stream_url: 'https://example.com/audio.mp3'}

    stub_request(:put, uri).with(request(body: params)).to_return(response)

    assert_kind_of Nexmo::Response, stream.start(call_uuid, params)
  end

  def test_stop_method
    stub_request(:delete, uri).with(request).to_return(response)

    assert_kind_of Nexmo::Response, stream.stop(call_uuid)
  end
end
