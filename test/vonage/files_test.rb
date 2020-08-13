# typed: false
require_relative './test'

class Vonage::FilesTest < Vonage::Test
  def files
    Vonage::Files.new(config)
  end

  def recording_uri
    'https://api.nexmo.com/v1/files/' + recording_id
  end

  def recording_id
    'xx-xx-xx-xx'
  end

  def recording_content
    'BODY'
  end

  def response
    {body: recording_content, headers: {'Content-Type' => 'application/octet-stream'}}
  end

  def filename
    'test/file.mp3'
  end

  def teardown
    File.unlink(filename) if File.exist?(filename)

    WebMock.reset!
  end

  def test_get_method_with_id
    stub_request(:get, recording_uri).with(request).to_return(response)

    response = files.get(recording_id)

    assert_kind_of Vonage::Response, response
    assert_equal recording_content, response.http_response.body
  end

  def test_get_method_with_url
    stub_request(:get, recording_uri).with(request).to_return(response)

    response = files.get(recording_uri)

    assert_kind_of Vonage::Response, response
    assert_equal recording_content, response.http_response.body
  end

  def test_save_method_with_id
    stub_request(:get, recording_uri).with(request).to_return(response)

    files.save(recording_id, filename)

    assert_equal recording_content, File.read(filename)
  end

  def test_save_method_with_url
    stub_request(:get, recording_uri).with(request).to_return(response)

    files.save(recording_uri, filename)

    assert_equal recording_content, File.read(filename)
  end
end
