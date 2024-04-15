# typed: false
require_relative '../test'

class Vonage::Video::RendersTest < Vonage::Test
  def renders
    Vonage::Video::Renders.new(config)
  end

  def uri
    'https://video.api.vonage.com/v2/project/' + application_id + '/render'
  end

  def experience_composer_id
    "1248e7070b81464c9789f46ad10e7764"
  end

  def test_start_method
    request_params = {
      sessionId: video_session_id,
      token: sample_video_token,
      url: 'https://example.com/'
    }

    stub_request(:post, uri).with(body: request_params).to_return(response)

    response = renders.start(
      session_id: video_session_id,
      token: sample_video_token,
      url: 'https://example.com/'
    )

    assert_kind_of Vonage::Response, response
  end

  def test_start_method_with_optional_params
    request_params = {
      sessionId: video_session_id,
      token: sample_video_token,
      url: 'https://example.com/',
      maxDuration: 1800,
      resolution: '1280x720',
      properties: {
        name: 'foo'
      }
    }

    stub_request(:post, uri).with(body: request_params).to_return(response)

    response = renders.start(
      session_id: video_session_id,
      token: sample_video_token,
      url: 'https://example.com/',
      max_duration: 1800,
      resolution: '1280x720',
      properties: {
        name: 'foo'
      }
    )

    assert_kind_of Vonage::Response, response
  end

  def test_start_method_without_session_id
    assert_raises(ArgumentError) do
      renders.start(
        token: sample_video_token,
        url: 'https://example.com/'
      )
    end
  end

  def test_start_method_without_token
    assert_raises(ArgumentError) do
      renders.start(
        session_id: video_session_id,
        url: 'https://example.com/'
      )
    end
  end

  def test_start_method_without_url
    assert_raises(ArgumentError) do
      renders.start(
        session_id: video_session_id,
        token: sample_video_token
      )
    end
  end

  def test_stop_method
    stub_request(:delete, uri + "/#{experience_composer_id}").to_return(response)

    assert_kind_of Vonage::Response, renders.stop(experience_composer_id: experience_composer_id)
  end

  def test_stop_method_without_experience_composer_id
    assert_raises(ArgumentError) { renders.stop }
  end

  def test_info_method
    stub_request(:get, uri + "/#{experience_composer_id}").to_return(response)

    assert_kind_of Vonage::Response, renders.info(experience_composer_id: experience_composer_id)
  end

  def test_info_method_without_experience_composer_id
    assert_raises(ArgumentError) { renders.info }
  end

  def test_list_method
    stub_request(:get, uri).to_return(video_list_response)

    renders_list = renders.list

    assert_kind_of Vonage::Video::Renders::ListResponse, renders_list
    renders_list.each { |render| assert_kind_of Vonage::Entity, render }
  end

  def test_list_method_with_optional_params
    stub_request(:get, uri + '?offset=10&count=20').to_return(video_list_response)

    renders_list = renders.list(offset: 10, count: 20)

    assert_kind_of Vonage::Video::Renders::ListResponse, renders_list
    renders_list.each { |render| assert_kind_of Vonage::Entity, render }
  end
end
