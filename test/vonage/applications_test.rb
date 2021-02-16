# typed: false
require_relative './test'

class Vonage::ApplicationsTest < Vonage::Test
  def applications
    Vonage::Applications.new(config)
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

    stub_request(:post, applications_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, applications.create(params)
  end

  def test_list_method
    params = {page_size: 20}

    stub_request(:get, applications_uri).with(request(query: params, headers: headers)).to_return(applications_response)

    response = applications.list(params)

    response.each{|resp| assert_kind_of Vonage::Applications::ListResponse, resp }
  end

  def test_list_pagination
    stub_request(:get, applications_uri).with(request(query: { page_size: 1 }, headers: headers)).to_return(
      { headers: response_headers, body: '{"page_size": 1, "page": 1, "total_items": 2, "total_pages": 2, "_embedded": { "applications": [{"id": "dummy-test-id-123"}] } }' }
    )

    stub_request(:get, applications_uri).with(request(query: { page_size: 1, page: 2 }, headers: headers)).to_return(
      { headers: response_headers, body: '{"page_size": 1, "page": 2, "total_items": 2, "total_pages": 2, "_embedded": { "applications": [{"id": "dummy-test-id-456"}] } }' }
    )
    response = applications.list(page_size: 1)

    assert_equal(2, response._embedded.applications.size)
  end

  def test_get_method
    stub_request(:get, application_uri).with(request(headers: headers)).to_return(response)

    assert_kind_of Vonage::Response, applications.get(application_id)
  end

  def test_update_method
    params = {name: 'Example Application'}

    stub_request(:put, application_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, applications.update(application_id, params)
  end

  def test_delete_method
    stub_request(:delete, application_uri).with(request(headers: headers)).to_return(status: 204)

    assert_kind_of Vonage::Response, applications.delete(application_id)
  end
end
