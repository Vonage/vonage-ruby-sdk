# typed: false
require_relative '../test'

class Vonage::Video::SignalsTest < Vonage::Test
  def signals
    Vonage::Video::Signals.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/session/' + video_session_id
  end

  def test_send_to_one_method
    connection_id = '1234567890abcdef1234567890abcdef1234567890'
    params = {application_id: application_id, session_id: video_session_id, connection_id: connection_id, type: 'chat', data: 'Hello'}
    request_params = {type: 'chat', data: 'Hello'}

    stub_request(:post, uri + '/connection/' + connection_id + '/signal').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, signals.send_to_one(**params)
  end

  def test_send_to_all_method
    params = {application_id: application_id, session_id: video_session_id, type: 'chat', data: 'Hello'}
    request_params = {type: 'chat', data: 'Hello'}

    stub_request(:post, uri + '/signal').with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, signals.send_to_all(**params)
  end
end
