require_relative './test'

class NexmoCallsTest < Nexmo::Test
  def calls
    Nexmo::Calls.new(client)
  end

  def calls_uri
    'https://api.nexmo.com/v1/calls'
  end

  def call_uri
    'https://api.nexmo.com/v1/calls/' + call_uuid
  end

  def call_uuid
    'xx-xx-xx-xx'
  end

  def headers
    {'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/}
  end

  def test_create_method
    headers = {
      'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/,
      'Content-Type' => 'application/json'
    }

    params = {
      to: [{type: 'phone', number: '14843331234'}],
      from: {type: 'phone', number: '14843335555'},
      answer_url: ['https://example.com/answer']
    }

    request = stub_request(:post, calls_uri).with(headers: headers, body: params).to_return(response)

    assert_equal response_object, calls.create(params)
    assert_requested request
  end

  def test_list_method
    params = {status: 'completed'}

    request = stub_request(:get, calls_uri).with(headers: headers, query: params).to_return(response)

    assert_equal response_object, calls.list(params)
    assert_requested request
  end

  def test_get_method
    request = stub_request(:get, call_uri).with(headers: headers).to_return(response)

    assert_equal response_object, calls.get(call_uuid)
    assert_requested request
  end

  def test_update_method
    params = {action: 'hangup'}

    request = stub_request(:put, call_uri).with(headers: headers, body: params).to_return(response)

    assert_equal response_object, calls.update(call_uuid, params)
    assert_requested request
  end
end
