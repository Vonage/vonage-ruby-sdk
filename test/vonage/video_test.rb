# typed: false
require_relative './test'

class Vonage::VideoTest < Vonage::Test
  def video
    Vonage::Video.new(config)
  end

  def video_uri
    'https://video.api.vonage.com'
  end

  def test_create_method
    stub_request(:post, video_uri + '/session/create').with(headers: headers).to_return(response)

    assert_kind_of Vonage::Response, video.create_session
  end

  def test_create_method_with_params
    params = {
      archive_mode: 'always',
      location: '10.1.200.30',
      p2p_preference: 'disabled'
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
      p2p_preference: 'disabled'
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

  def test_streams_method
    assert_kind_of Vonage::Video::Streams, video.streams
  end

  def test_archives_method
    assert_kind_of Vonage::Video::Archives, video.archives
  end

  def test_moderation_method
    assert_kind_of Vonage::Video::Moderation, video.moderation
  end

  def test_signals_method
    assert_kind_of Vonage::Video::Signals, video.signals
  end
end
