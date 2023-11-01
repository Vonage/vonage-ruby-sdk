# typed: false

class Vonage::Meetings::SessionsTest < Vonage::Test
  def sessions
    Vonage::Meetings::Sessions.new(config)
  end

  def sessions_uri
    "https://" + meetings_host + "/v1/meetings/sessions/" + meetings_id +
      "/recordings"
  end

  def list_response
    {
      headers: response_headers,
      body: '{"_embedded": {"recordings": [{"key":"value"}, {"key":"value"}, {"key":"value"}]}}'
    }
  end

  def test_list_recordings_method
    stub_request(:get, sessions_uri).to_return(list_response)
    recordings_list = sessions.list_recordings(session_id: meetings_id)

    assert_kind_of Vonage::Meetings::Sessions::ListResponse, recordings_list
    recordings_list.each do |recording|
      assert_kind_of Vonage::Entity, recording
    end
  end

  def test_list_recordings_method_session_id
    assert_raises(ArgumentError) { sessions.list_recordings }
  end
end
