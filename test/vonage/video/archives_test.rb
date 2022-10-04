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
    params = {application_id: application_id}

    stub_request(:get, uri).to_return(video_list_response)

    assert_kind_of Vonage::Video::ListResponse, archives.list(**params)
  end

  def test_info_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {application_id: application_id, archive_id: archive_id}

    stub_request(:get, uri + '/' + archive_id).to_return(response)

    assert_kind_of Vonage::Response, archives.info(**params)
  end

  def test_start_method
    params = {application_id: application_id, session_id: video_session_id}
    request_params = {session_id: video_session_id}

    stub_request(:post, uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.start(**params)
  end

  def test_stop_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {application_id: application_id, archive_id: archive_id}

    stub_request(:post, uri + '/' + archive_id + '/stop').to_return(response)

    assert_kind_of Vonage::Response, archives.stop(**params)
  end

  def test_delete_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {application_id: application_id, archive_id: archive_id}

    stub_request(:delete, uri + '/' + archive_id).to_return(response)

    assert_kind_of Vonage::Response, archives.delete(**params)
  end

  def test_add_stream_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'
    params = {application_id: application_id, archive_id: archive_id, add_stream: stream_id}
    request_params = {addStream: stream_id}

    stub_request(:patch, uri + '/' + archive_id + '/streams').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.add_stream(**params)
  end

  def test_remove_stream_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    stream_id = 'c2854e26-648g-568b-cf98-f11gd421c93c'
    params = {application_id: application_id, archive_id: archive_id, remove_stream: stream_id}
    request_params = {removeStream: stream_id}

    stub_request(:patch, uri + '/' + archive_id + '/streams').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, archives.remove_stream(**params)
  end

  def test_change_layout_method
    archive_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {
      application_id: application_id, 
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
