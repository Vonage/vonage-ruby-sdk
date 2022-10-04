# typed: false
require_relative '../test'

class Vonage::Video::StreamsTest < Vonage::Test
  def streams
    Vonage::Video::Streams.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/session/' + video_session_id + '/stream'
  end

  def test_list_method
    params = {application_id: application_id, session_id: video_session_id}

    stub_request(:get, uri).to_return(video_list_response)

    assert_kind_of Vonage::Video::ListResponse, streams.list(**params)
  end

  def test_info_method
    stream_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {application_id: application_id, session_id: video_session_id, stream_id: stream_id}

    stub_request(:get, uri + '/' + stream_id).to_return(response)

    assert_kind_of Vonage::Response, streams.info(**params)
  end

  def test_change_layout_method
    stream_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    params = {application_id: application_id, session_id: video_session_id, items: [{id: stream_id, layoutClassList: ['full']}]}
    request_params = {items: [{id: stream_id, layoutClassList: ['full']}]}

    stub_request(:put, uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, streams.change_layout(**params)
  end
end
