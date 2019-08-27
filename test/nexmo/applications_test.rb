require_relative './test'

class NexmoApplicationsTest < Nexmo::Test
  def applications
    Nexmo::Applications.new(config)
  end

  def applications_uri
    'https://api.nexmo.com/v2/applications'
  end

  def application_uri
    'https://api.nexmo.com/v2/applications/' + application_id
  end

  def authorization
    basic_authorization
  end

  def headers
    {'Content-Type' => 'application/json'}
  end

  def test_create_method
    params = {name: 'Example Application'}

    request_stub = stub_request(:post, applications_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, applications.create(params)
    assert_requested request_stub
  end

  def test_list_method
    params = {page_size: 20}

    request_stub = stub_request(:get, applications_uri).with(request(query: params, headers: headers)).to_return(response)

    assert_equal response_object, applications.list(params)
    assert_requested request_stub
  end

  def test_get_method
    request_stub = stub_request(:get, application_uri).with(request(headers: headers)).to_return(response)

    assert_equal response_object, applications.get(application_id)
    assert_requested request_stub
  end

  def test_update_method
    params = {name: 'Example Application'}

    request_stub = stub_request(:put, application_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, applications.update(application_id, params)
    assert_requested request_stub
  end

  def test_delete_method
    request_stub = stub_request(:delete, application_uri).with(request(headers: headers)).to_return(status: 204)

    assert_equal :no_content, applications.delete(application_id)
    assert_requested request_stub
  end
end
