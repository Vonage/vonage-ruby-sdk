# typed: false
require_relative '../test'

class Vonage::Voice::StreamTest < Vonage::Test
  def stream
    Vonage::Voice::Stream.new(config)
  end

  def uri
    'https://api.nexmo.com/v1/calls/' + call_uuid + '/stream'
  end

  def test_start_method
    params = {stream_url: 'https://example.com/audio.mp3'}

    stub_request(:put, uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, stream.start(call_uuid, params)
  end

  def test_stop_method
    stub_request(:delete, uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, stream.stop(call_uuid)
  end
end
