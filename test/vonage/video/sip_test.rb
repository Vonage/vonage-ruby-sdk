# typed: false
require_relative '../test'

class Vonage::Video::SIPTest < Vonage::Test
  def sip
    Vonage::Video::SIP.new(config)
  end

  def sip_dial_uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/dial'
  end

  def dtmf_session_uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/session/' + video_id + '/play-dtmf'
  end

  def dtmf_connection_uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/session/' + video_id + '/connection/' + video_connection_id + '/play-dtmf'
  end

  def token
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NzY1NDU1NTcsImV4cCI6MT'
  end

  def test_dial_method
    request_params = {
      sessionId: video_id,
      token: token,
      sip: {
        uri: 'sip:user@sip.partner.com;transport=tls'
      }
    }

    stub_request(:post, sip_dial_uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, sip.dial(
      session_id: video_id,
      token: token,
      sip_uri: 'sip:user@sip.partner.com;transport=tls'
    )
  end

  def test_dial_method_with_optional_params
    request_params = {
      sessionId: video_id,
      token: token,
      sip: {
        uri: 'sip:user@sip.partner.com;transport=tls',
        from: 'from@example.com',
        secure: true,
        observeForceMute: true,
        headers: {
          headerKey: 'some-value'
        }
      }
    }

    stub_request(:post, sip_dial_uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, sip.dial(
      session_id: video_id,
      token: token,
      sip_uri: 'sip:user@sip.partner.com;transport=tls',
      from: 'from@example.com',
      secure: true,
      observeForceMute: true,
      headers: {
        headerKey: 'some-value'
      }
    )
  end

  def test_dial_method_without_session_id
    assert_raises(ArgumentError) { sip.dial(token: token, sip_uri: 'sip:user@sip.partner.com;transport=tls') }
  end

  def test_dial_method_without_token
    assert_raises(ArgumentError) { sip.dial(session_id: video_session_id, sip_uri: 'sip:user@sip.partner.com;transport=tls') }
  end

  def test_dial_method_without_sip_uri
    assert_raises(ArgumentError) { sip.dial(session_id: video_session_id, token: token) }
  end

  def test_play_dtmf_to_session_method
    request_params = {digits: '1713'}

    stub_request(:post, dtmf_session_uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, sip.play_dtmf_to_session(session_id: video_id, dtmf_digits: '1713')
  end

  def test_play_dtmf_to_session_method_without_session_id
    assert_raises(ArgumentError) { sip.play_dtmf_to_session(dtmf_digits: '1713') }
  end

  def test_play_dtmf_to_session_method_without_dtmf_digits
    assert_raises(ArgumentError) { sip.play_dtmf_to_session(session_id: video_id) }
  end

  def test_play_dtmf_to_connection_method
    request_params = {digits: '1713'}

    stub_request(:post, dtmf_connection_uri).with(body: request_params).to_return(response)

    assert_kind_of Vonage::Response, sip.play_dtmf_to_connection(
      session_id: video_id,
      connection_id: video_connection_id,
      dtmf_digits: '1713'
    )
  end

  def test_play_dtmf_to_connection_method_without_session_id
    assert_raises(ArgumentError) { sip.play_dtmf_to_connection(connection_id: video_connection_id, dtmf_digits: '1713') }
  end

  def test_play_dtmf_to_connection_method_without_connection_id
    assert_raises(ArgumentError) { sip.play_dtmf_to_connection(session_id: video_id, dtmf_digits: '1713') }
  end

  def test_play_dtmf_to_connection_method_without_dtmf_digits
    assert_raises(ArgumentError) { sip.play_dtmf_to_connection(session_id: video_id, connection_id: video_connection_id) }
  end
end
