require_relative './test'

class NexmoMediaTest < Nexmo::Test
  def uuid
    'aaaaaaaa-bbbb-cccc-dddd-0123456789ab'
  end

  def media
    Nexmo::Media.new(client)
  end

  def headers
    {'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/}
  end

  def media_uri
    'https://api.nexmo.com/v3/media'
  end

  def media_info_uri
    'https://api.nexmo.com/v3/media/' + uuid + '/info'
  end

  def test_upload_method
    headers = {
      'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/,
      'Content-Type' => 'multipart/form-data'
    }

    request = stub_request(:post, media_uri).with(headers: headers).to_return(status: 201)

    assert_equal :created, media.upload(filedata: 'foo bar baz', filename: 'foo.txt')
    assert_requested request
  end

  def test_list_method
    params = {page_size: 50}

    request = stub_request(:get, media_uri).with(headers: headers, query: params).to_return(response)

    assert_equal response_object, media.list(params)
    assert_requested request
  end

  def test_get_method
    request = stub_request(:get, media_info_uri).with(headers: headers).to_return(response)

    assert_equal response_object, media.get(uuid)
    assert_requested request
  end

  def test_delete_method
    request = stub_request(:delete, media_info_uri).with(headers: headers).to_return(status: 204)

    assert_equal :no_content, media.delete(uuid)
    assert_requested request
  end
end
