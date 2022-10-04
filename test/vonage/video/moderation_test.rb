# typed: false
require_relative '../test'

class Vonage::Video::SignalsTest < Vonage::Test
  def moderation
    Vonage::Video::Moderation.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/session/' + video_session_id
  end

  def test_force_disconnect_method
    connection_id = '1234567890abcdef1234567890abcdef1234567890'
    params = {application_id: application_id, session_id: video_session_id, connection_id: connection_id}

    stub_request(:delete, uri + '/connection/' + connection_id).to_return(response)

    assert_kind_of Vonage::Response, moderation.force_disconnect(**params)
  end

  def test_mute_single_stream_method
    stream_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {application_id: application_id, session_id: video_session_id, stream_id: stream_id}

    stub_request(:post, uri + '/stream/' + stream_id + '/mute').to_return(response)

    assert_kind_of Vonage::Response, moderation.mute_single_stream(**params)
  end

  def test_mute_multiple_streams_method
    params = {application_id: application_id, session_id: video_session_id}

    stub_request(:post, uri + '/mute').to_return(response)

    assert_kind_of Vonage::Response, moderation.mute_multiple_streams(**params)
  end
end
