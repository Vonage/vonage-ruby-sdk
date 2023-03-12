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
    stub_request(:get, uri).to_return(video_list_response)

    streams_list = streams.list(session_id: video_session_id)

    assert_kind_of Vonage::Video::Streams::ListResponse, streams_list
    streams_list.each { |stream| assert_kind_of Vonage::Entity, stream }
  end

  def test_info_method
    stream_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    stub_request(:get, uri + '/' + stream_id).to_return(response)

    assert_kind_of Vonage::Response, streams.info(session_id: video_session_id, stream_id: stream_id)
  end

  def test_change_layout_method
    stream_id = 'b1963d15-537f-459a-be89-e00fc310b82b'
    request_params = {items: [{id: stream_id, layoutClassList: ['full']}]}
    stub_request(:put, uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, streams.change_layout(session_id: video_session_id, items: [{id: stream_id, layoutClassList: ['full']}])
  end
end
