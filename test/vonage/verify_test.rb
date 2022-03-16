# typed: false
require_relative './test'

class Vonage::VerifyTest < Vonage::Test
  def verify
    Vonage::Verify.new(config)
  end

  def request_id
    '8g88g88eg8g8gg9g90'
  end

  def response
    {
      headers: response_headers,
      body: '{"status":"0"}'
    }
  end

  def error_response
    {
      headers: response_headers,
      body: '{"status":"101","error_text":"No response found"}'
    }
  end

  def test_request_method
    uri = 'https://api.nexmo.com/verify/json'

    params = {number: msisdn, brand: 'ExampleApp'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, verify.request(params)

    error = assert_raises Vonage::ServiceError do
      verify.request(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_check_method
    uri = 'https://api.nexmo.com/verify/check/json'

    params = {request_id: request_id, code: '123445'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, verify.check(params)

    error = assert_raises Vonage::ServiceError do
      verify.check(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_search_method
    uri = 'https://api.nexmo.com/verify/search/json'

    params = {request_id: request_id}

    stub_request(:get, uri).with(query: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, verify.search(params)

    error = assert_raises Vonage::ServiceError do
      verify.search(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_control_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'cancel'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, verify.control(params)

    error = assert_raises Vonage::ServiceError do
      verify.control(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_cancel_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'cancel'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, verify.cancel(request_id)

    error = assert_raises Vonage::ServiceError do
      verify.cancel(request_id)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_trigger_next_event_method
    uri = 'https://api.nexmo.com/verify/control/json'

    params = {request_id: request_id, cmd: 'trigger_next_event'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, verify.trigger_next_event(request_id)

    error = assert_raises Vonage::ServiceError do
      verify.trigger_next_event(request_id)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_psd2_method
    uri = 'https://api.nexmo.com/verify/psd2/json'

    params = {number: msisdn, payee: 'ExampleApp', amount: 48.00}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, verify.psd2(params)

    error = assert_raises Vonage::ServiceError do
      verify.psd2(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end
end
