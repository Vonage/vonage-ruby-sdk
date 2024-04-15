# typed: false
require_relative '../test'

class Vonage::Video::CaptionsTest < Vonage::Test
  def captions
    Vonage::Video::Captions.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/captions'
  end

  def test_start_method
    request_params = {sessionId: video_session_id, token: sample_video_token}
    stub_request(:post, uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, captions.start(session_id: video_session_id, token: sample_video_token)
  end

  def test_start_method_with_optional_params
    request_params = {
      sessionId: video_session_id,
      token: sample_video_token,
      languageCode: 'en-US',
      maxDuration: 300,
      partialCaptions: false,
      statusCallbackUrl: 'https://send-status-to.me'
    }

    stub_request(:post, uri).with(body: request_params).to_return(response)

    response = captions.start(
      session_id: video_session_id,
      token: sample_video_token,
      language_code: 'en-US',
      max_duration: 300,
      partial_captions: false,
      status_callback_url: 'https://send-status-to.me'
    )

    assert_kind_of Vonage::Response, response
  end

  def test_start_method_without_session_id
    assert_raises(ArgumentError) { captions.start(token: sample_video_token) }
  end

  def test_start_method_without_token
    assert_raises(ArgumentError) { captions.start(session_id: video_session_id) }
  end

  def test_stop_method
    captions_id = "7c0680fc-6274-4de5-a66f-d0648e8d3ac2"
    stub_request(:post, uri + "/#{captions_id}/stop").to_return(response)

    assert_kind_of Vonage::Response, captions.stop(captions_id: captions_id)
  end

  def test_stop_method_without_captions_id
    assert_raises(ArgumentError) { captions.stop }
  end
end
