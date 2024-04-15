# typed: false
require_relative '../test'

class Vonage::Video::WebSocketTest < Vonage::Test
  def web_socket
    Vonage::Video::WebSocket.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/connect'
  end

  def test_connect_method
    request_params = {
      sessionId: video_session_id,
      token: sample_video_token,
      websocket: {
        uri: 'wss://example.com/ws-endpoint'
      }
    }

    stub_request(:post, uri).with(body: request_params).to_return(response)

    response = web_socket.connect(
      session_id: video_session_id,
      token: sample_video_token,
      websocket: {
        uri: 'wss://example.com/ws-endpoint'
      }
    )

    assert_kind_of Vonage::Response, response
  end

  def test_connect_method_with_optional_params
    request_params = {
      sessionId: video_session_id,
      token: sample_video_token,
      websocket: {
        uri: 'wss://example.com/ws-endpoint',
        streams: ['stream1', 'stream2'],
        headers: { property1: 'foo', property2: 'bar' },
        audioRate: 16000
      }
    }

    stub_request(:post, uri).with(body: request_params).to_return(response)

    response = web_socket.connect(
      session_id: video_session_id,
      token: sample_video_token,
      websocket: {
        uri: 'wss://example.com/ws-endpoint',
        streams: ['stream1', 'stream2'],
        headers: { property1: 'foo', property2: 'bar' },
        audio_rate: 16000
      }
    )

    assert_kind_of Vonage::Response, response
  end

  def test_connect_method_without_session_id
    assert_raises(ArgumentError) do
      web_socket.connect(
        token: sample_video_token,
        websocket: {
          uri: 'wss://example.com/ws-endpoint'
        }
      )
    end
  end

  def test_connect_method_without_token
    assert_raises(ArgumentError) do
      web_socket.connect(
        session_id: video_session_id,
        websocket: {
          uri: 'wss://example.com/ws-endpoint'
        }
      )
    end
  end

  def test_connect_method_without_websocket
    assert_raises(ArgumentError) do
      web_socket.connect(
        session_id: video_session_id,
        token: sample_video_token
      )
    end
  end

  def test_connect_method_without_websocket_uri
    assert_raises(ArgumentError) do
      web_socket.connect(
        session_id: video_session_id,
        token: sample_video_token,
        websocket: {}
      )
    end
  end
end
