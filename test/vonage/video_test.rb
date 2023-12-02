# typed: false
require_relative './test'

class Vonage::VideoTest < Vonage::Test
  def video
    Vonage::Video.new(config)
  end

  def video_uri
    'https://video.api.vonage.com'
  end

  def decode_jwt_payload(token)
    JWT.decode(token, private_key, false, {algorithm: 'HS256'}).first
  end

  def create_session_response_body
    "[{\"session_id\":\"2_MX5lMzM2ZmUxOS01MWNhLTRiNTktYTczOS1jNzA3MWIzZjY5Y2N-\"}]"
  end

  def response
    { body: create_session_response_body, headers: response_headers }
  end

  def test_create_method
    stub_request(:post, video_uri + '/session/create').with(headers: headers).to_return(response)

    assert_kind_of Vonage::Response, video.create_session
  end

  def test_create_method_with_params
    params = {
      archive_mode: 'always',
      location: '10.1.200.30',
      media_mode: 'routed'
    }
    request_params = {
      'archiveMode' => 'always',
      'location' => '10.1.200.30',
      'p2p.preference' => 'disabled'
    }

    stub_request(:post, video_uri + '/session/create').with(headers: headers, body: request_params).to_return(response)

    assert_kind_of Vonage::Response, video.create_session(**params)
  end

  def test_create_method_with_media_mode_relayed
    params = {
      location: '10.1.200.30',
      media_mode: 'relayed'
    }
    request_params = {
      'archiveMode' => 'manual',
      'location' => '10.1.200.30',
      'p2p.preference' => 'enabled'
    }

    stub_request(:post, video_uri + '/session/create').with(headers: headers, body: request_params).to_return(response)

    assert_kind_of Vonage::Response, video.create_session(**params)
  end

  def test_create_method_with_media_mode_relayed_but_archive_mode_always
    params = {
      archive_mode: 'always',
      location: '10.1.200.30',
      media_mode: 'relayed'
    }
    request_params = {
      'archiveMode' => 'always',
      'location' => '10.1.200.30',
      'p2p.preference' => 'disabled'
    }

    stub_request(:post, video_uri + '/session/create').with(headers: headers, body: request_params).to_return(response)

    assert_kind_of Vonage::Response, video.create_session(**params)
  end

  def test_create_method_params_match_response_methods
    params = {
      archive_mode: 'always',
      location: '10.1.200.30',
      media_mode: 'routed'
    }
    request_params = {
      'archiveMode' => 'always',
      'location' => '10.1.200.30',
      'p2p.preference' => 'disabled'
    }

    stub_request(:post, video_uri + '/session/create').with(headers: headers, body: request_params).to_return(response)
    response = video.create_session(**params)

    params.keys.each do |key|
      assert_equal params[key], response.send(key)
    end
  end


  def test_generate_client_token
    token = video.generate_client_token(session_id: 'abc123')
    decoded_token_payload = decode_jwt_payload(token)

    assert_equal 'abc123', decoded_token_payload['session_id']
  end

  def test_generate_client_token_with_custom_options
    expire_time = Time.now.to_i + 500
    token = video.generate_client_token(session_id: 'abc123', role: 'moderator', initial_layout_class_list: ['foo', 'bar'], data: 'test', expire_time: expire_time)
    decoded_token_payload = decode_jwt_payload(token)

    assert_equal 'abc123', decoded_token_payload['session_id']
    assert_equal 'moderator', decoded_token_payload['role']
    assert_equal 'foo bar', decoded_token_payload['initial_layout_class_list']
    assert_equal 'test', decoded_token_payload['data']
    assert_equal expire_time, decoded_token_payload['exp']
  end

  def test_streams_method
    assert_kind_of Vonage::Video::Streams, video.streams
  end

  def test_archives_method
    assert_kind_of Vonage::Video::Archives, video.archives
  end

  def test_broadcasts_method
    assert_kind_of Vonage::Video::Broadcasts, video.broadcasts
  end

  def test_moderation_method
    assert_kind_of Vonage::Video::Moderation, video.moderation
  end

  def test_signals_method
    assert_kind_of Vonage::Video::Signals, video.signals
  end
end
