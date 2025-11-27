# typed: false
require_relative '../test'

class Vonage::Video::ConnectionsTest < Vonage::Test
  def connections
    Vonage::Video::Connections.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/session/' + video_session_id + '/connection'
  end

  def test_list_method
    stub_request(:get, uri).to_return(video_list_response)

    connections_list = connections.list(session_id: video_session_id)

    assert_kind_of Vonage::Video::Connections::ListResponse, connections_list
    connections_list.each { |connection| assert_kind_of Vonage::Entity, connection }
  end
end
