require_relative './test'

class NexmoFilesTest < Nexmo::Test
  def files
    Nexmo::Files.new(client)
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

  def headers
    {'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/}
  end

  def teardown
    File.unlink(filename) if File.exist?(filename)

    WebMock.reset!
  end

  def test_get_method_with_id
    request = stub_request(:get, recording_uri).with(headers: headers).to_return(response)

    assert_equal recording_content, files.get(recording_id)
    assert_requested request
  end

  def test_get_method_with_url
    request = stub_request(:get, recording_uri).with(headers: headers).to_return(response)

    assert_equal recording_content, files.get(recording_uri)
    assert_requested request
  end

  def test_save_method_with_id
    request = stub_request(:get, recording_uri).with(headers: headers).to_return(response)

    files.save(recording_id, filename)

    assert_equal recording_content, File.read(filename)
    assert_requested request
  end

  def test_save_method_with_url
    request = stub_request(:get, recording_uri).with(headers: headers).to_return(response)

    files.save(recording_uri, filename)

    assert_equal recording_content, File.read(filename)
    assert_requested request
  end
end
