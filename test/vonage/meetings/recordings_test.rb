# typed: false

class Vonage::Meetings::RecordingsTest < Vonage::Test
  def recordings
    Vonage::Meetings::Recordings.new(config)
  end

  def recording_uri
    "https://" + meetings_host + "/beta/meetings/recordings/" + meetings_id
  end

  def test_info_method
    stub_request(:get, recording_uri).to_return(response)

    assert_kind_of Vonage::Response, recordings.info(recording_id: meetings_id)
  end

  def test_info_method_without_recording_id
    assert_raises(ArgumentError) { recordings.info }
  end

  def test_delete_method
    stub_request(:delete, recording_uri).to_return(response)

    assert_kind_of Vonage::Response,
                   recordings.delete(recording_id: meetings_id)
  end

  def test_delete_method_without_recording_id
    assert_raises(ArgumentError) { recordings.delete }
  end
end
