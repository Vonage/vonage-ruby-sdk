require_relative './test'

class NexmoApplicationsTest < Nexmo::Test
  def applications
    Nexmo::Applications.new(client)
  end

  def applications_uri
    'https://api.nexmo.com/v1/applications'
  end

  def application_uri
    'https://api.nexmo.com/v1/applications/' + application_id
  end

  def application_id
    'xx-xx-xx-xx'
  end

  def test_create_method
    params = {
      name: 'Example Application',
      type: 'voice',
      answer_url: 'https://example.com/answer',
      event_url: 'https://example.com/event'
    }

    request = stub_request(:post, applications_uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, applications.create(params)
    assert_requested request
  end

  def test_list_method
    params = {page_size: 20}

    request = stub_request(:get, applications_uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, applications.list(params)
    assert_requested request
  end

  def test_get_method
    request = stub_request(:get, application_uri).with(query: api_key_and_secret).to_return(response)

    assert_equal response_object, applications.get(application_id)
    assert_requested request
  end

  def test_update_method
    params = {answer_url: 'https://example.com/ncco'}

    request = stub_request(:put, application_uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, applications.update(application_id, params)
    assert_requested request
  end

  def test_delete_method
    request = stub_request(:delete, application_uri).with(query: api_key_and_secret).to_return(status: 204)

    assert_equal :no_content, applications.delete(application_id)
    assert_requested request
  end
end
