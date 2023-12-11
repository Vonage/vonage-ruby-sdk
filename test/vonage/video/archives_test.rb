# typed: false
require_relative '../test'

class Vonage::Video::ArchivesTest < Vonage::Test
  def archives
    Vonage::Video::Archives.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/archive'
  end

  def test_list_method
    stub_request(:get, uri).to_return(video_list_response)

    archives_list = archives.list

    assert_kind_of Vonage::Video::Archives::ListResponse, archives_list
    archives_list.each { |archive| assert_kind_of Vonage::Entity, archive }
  end

  def test_info_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'

    stub_request(:get, uri + '/' + archive_id).to_return(response)

    assert_kind_of Vonage::Response, archives.info(archive_id: archive_id)
  end

  def test_info_method_without_archive_id
    assert_raises(ArgumentError) { archives.info }
  end

  def test_start_method
    request_params = {sessionId: video_session_id}

    stub_request(:post, uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.start(session_id: video_session_id)
  end

  def test_start_method_with_optional_params
    request_params = {
      sessionId: video_session_id,
      resolution: '640x480',
      streamMode: 'auto'
    }

    stub_request(:post, uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.start(
      session_id: video_session_id,
      resolution: '640x480',
      stream_mode: 'auto'
    )
  end

  def test_start_method_without_session_id
    assert_raises(ArgumentError) { archives.start }
  end

  def test_stop_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'

    stub_request(:post, uri + '/' + archive_id + '/stop').to_return(response)

    assert_kind_of Vonage::Response, archives.stop(archive_id: archive_id)
  end

  def test_stop_method_without_archive_id
    assert_raises(ArgumentError) { archives.stop }
  end

  def test_delete_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'

    stub_request(:delete, uri + '/' + archive_id).to_return(response)

    assert_kind_of Vonage::Response, archives.delete(archive_id: archive_id)
  end

  def test_delete_method_without_archive_id
    assert_raises(ArgumentError) { archives.delete }
  end

  def test_add_stream_method
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'
    request_params = {addStream: stream_id}

    stub_request(:patch, uri + '/' + video_id + '/streams').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.add_stream(archive_id: video_id, stream_id: stream_id)
  end

  def test_add_stream_method_with_optional_params
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'
    request_params = {
      addStream: stream_id,
      hasAudio: true,
      hasVideo: true
    }

    stub_request(:patch, uri + '/' + video_id  + '/streams').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.add_stream(archive_id: video_id, stream_id: stream_id, has_audio: true, has_video: true)
  end

  def test_add_stream_method_without_archive_id
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'

    assert_raises(ArgumentError) { archives.add_stream(stream_id: stream_id) }
  end

  def test_add_stream_method_without_stream_id
    assert_raises(ArgumentError) { archives.add_stream(archive_id: video_id) }
  end

  def test_remove_stream_method
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'
    request_params = {removeStream: stream_id}

    stub_request(:patch, uri + '/' + video_id + '/streams').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.remove_stream(archive_id: video_id, stream_id: stream_id)
  end

  def test_remove_stream_method_without_archive_id
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'

    assert_raises(ArgumentError) { archives.remove_stream(stream_id: stream_id) }
  end

  def test_remove_stream_method_without_stream_id
    assert_raises(ArgumentError) { archives.remove_stream(archive_id: video_id) }
  end

  def test_change_layout_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {
      archive_id: archive_id,
      type: "bestFit",
      stylesheet: "stream.instructor {position: absolute; width: 100%;  height:50%;}",
      screenshare_type: "pip"
    }
    request_params = {
      type: "bestFit",
      stylesheet: "stream.instructor {position: absolute; width: 100%;  height:50%;}",
      screenshareType: "pip"
    }

    stub_request(:put, uri + '/' + archive_id + '/layout').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.change_layout(**params)
  end
end
