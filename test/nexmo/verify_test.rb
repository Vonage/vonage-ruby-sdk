require_relative './test'

class Nexmo::VerifyTest < Nexmo::Test
  def verify
    Nexmo::Verify.new(config)
  end

  def request_id
    '8g88g88eg8g8gg9g90'
  end

  def test_request_method
    uri = 'https://api.nexmo.com/verify/json'

    params = {number: msisdn, brand: 'ExampleApp'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Nexmo::Verify::Response, verify.request(params)
  end

  def test_check_method
    uri = 'https://api.nexmo.com/verify/check/json'

    params = {request_id: request_id, code: '123445'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Nexmo::Verify::Response, verify.check(params)
  end

  def test_search_method
    uri = 'https://api.nexmo.com/verify/search/json'

    params = {request_id: request_id}

    stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Nexmo::Verify::Response, verify.search(params)
  end

  def test_control_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'cancel'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Nexmo::Verify::Response, verify.control(params)
  end

  def test_cancel_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'cancel'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Nexmo::Verify::Response, verify.cancel(request_id)
  end

  def test_trigger_next_event_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'trigger_next_event'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Nexmo::Verify::Response, verify.trigger_next_event(request_id)
  end
end
