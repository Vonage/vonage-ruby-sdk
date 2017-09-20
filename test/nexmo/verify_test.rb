require_relative './test'

class NexmoVerifyTest < Nexmo::Test
  def verify
    Nexmo::Verify.new(client)
  end

  def request_id
    '8g88g88eg8g8gg9g90'
  end

  def test_request_method
    uri = 'https://api.nexmo.com/verify/json'

    params = {number: '447700900000', brand: 'ExampleApp'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, verify.request(params)
    assert_requested request
  end

  def test_check_method
    uri = 'https://api.nexmo.com/verify/check/json'

    params = {request_id: request_id, code: '123445'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, verify.check(params)
    assert_requested request
  end

  def test_search_method
    uri = 'https://api.nexmo.com/verify/search/json'

    params = {request_id: request_id}

    request = stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, verify.search(params)
    assert_requested request
  end

  def test_control_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'cancel'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, verify.control(params)
    assert_requested request
  end

  def test_cancel_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'cancel'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, verify.cancel(request_id)
    assert_requested request
  end

  def test_trigger_next_event_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'trigger_next_event'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, verify.trigger_next_event(request_id)
    assert_requested request
  end
end
