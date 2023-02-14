# typed: false
require_relative '../test'

class Vonage::Video::BroadcastsTest < Vonage::Test
  def broadcasts
    Vonage::Video::Broadcasts.new(config)
  end

  def broadcasts_uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/broadcast'
  end

  def broadcast_uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/broadcast/' + video_id
  end

  def test_list_method
    stub_request(:get, broadcasts_uri).to_return(video_list_response)

    broadcast_list = broadcasts.list

    assert_kind_of Vonage::Video::Broadcasts::ListResponse, broadcast_list
    broadcast_list.each { |broadcast| assert_kind_of Vonage::Entity, broadcast }
  end

  def test_list_method_with_optional_params
    session_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {offset: 10, count: 20, session_id: session_id}

    stub_request(:get, broadcasts_uri + '?offset=10&count=20&sessionId=' + session_id).to_return(video_list_response)

    broadcast_list = broadcasts.list(**params)

    assert_kind_of Vonage::Video::Broadcasts::ListResponse, broadcast_list
    broadcast_list.each { |broadcast| assert_kind_of Vonage::Entity, broadcast }
  end

  def test_info_method
    stub_request(:get, broadcast_uri).to_return(response)

    assert_kind_of Vonage::Response, broadcasts.info(broadcast_id: video_id)
  end

  def test_info_method_without_broadcast_id
    assert_raises(ArgumentError) { broadcasts.info }
  end

  def test_start_method
    request_params = {session_id: video_session_id}

    stub_request(:post, broadcasts_uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, broadcasts.start(session_id: video_session_id)
  end

  def test_start_method_with_optional_params
    request_params = {
      session_id: video_session_id,
      resolution: '640x480',
      streamMode: 'auto'
    }

    stub_request(:post, broadcasts_uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, broadcasts.start(
      session_id: video_session_id,
      resolution: '640x480',
      streamMode: 'auto'
    )
  end

  def test_start_method_without_session_id
    assert_raises(ArgumentError) { broadcasts.start }
  end

  def test_stop_method
    stub_request(:post, broadcast_uri + '/stop').to_return(response)

    assert_kind_of Vonage::Response, broadcasts.stop(broadcast_id: video_id)
  end

  def test_stop_method_without_broadcast_id
    assert_raises(ArgumentError) { broadcasts.stop }
  end

  def test_add_stream_method
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'

    request_params = {
      addStream: stream_id
    }

    stub_request(:patch, broadcast_uri + '/streams').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, broadcasts.add_stream(broadcast_id: video_id, stream_id: stream_id)
  end

  def test_add_stream_method_with_optional_params
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'
    request_params = {
      addStream: stream_id,
      hasAudio: true,
      hasVideo: true
    }

    stub_request(:patch, broadcast_uri + '/streams').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, broadcasts.add_stream(broadcast_id: video_id, stream_id: stream_id, has_audio: true, has_video: true)
  end

  def test_add_stream_method_without_broadcast_id
    assert_raises(ArgumentError) { broadcasts.add_stream(stream_id: stream_id) }
  end

  def test_add_stream_method_without_stream_id
    assert_raises(ArgumentError) { broadcasts.add_stream(broadcast_id: video_id) }
  end

  def test_remove_stream_method
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'
    request_params = {removeStream: stream_id}

    stub_request(:patch, broadcast_uri + '/streams')).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.remove_stream(broadcast_id: video_id, stream_id: stream_id)
  end

  def test_remove_stream_method_without_broadcast_id
    assert_raises(ArgumentError) { broadcasts.remove_stream(stream_id: stream_id) }
  end

  def test_remove_stream_method_without_stream_id
    assert_raises(ArgumentError) { broadcasts.remove_stream(broadcast_id: video_id) }
  end

  def test_change_layout_method
    request_params = {
      type: "bestFit"
    }

    stub_request(:put, broadcast_uri + '/layout').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, broadcasts.change_layout(broadcast_id: video_id, type: "bestFit")
  end
end
