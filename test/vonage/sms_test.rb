# typed: false
require_relative './test'

class Vonage::SMSTest < Vonage::Test
  def sms
    Vonage::SMS.new(config)
  end

  def uri
    'https://rest.nexmo.com/sms/json'
  end

  def response
    {
      headers: response_headers,
      body: '{"messages":[{"status":"0"}]}'
    }
  end

  def error_response
    {
      headers: response_headers,
      body: '{"messages":[{"status":"1"}]}'
    }
  end

  def test_send_method
    params = {from: 'Ruby', to: msisdn, text: 'Hello from Ruby!'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response, error_response)

    assert_kind_of Vonage::Response, sms.send(params)

    error = assert_raises Vonage::ServiceError do
      sms.send(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_mapping_underscored_keys_to_hyphenated_string_keys
    params = {'status-report-req' => '1', 'text' => 'Hey'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, sms.send(text: 'Hey', status_report_req: 1)
  end

  def test_warn_when_sending_unicode_without_type
    io = StringIO.new

    sms = Vonage::SMS.new(config.merge(logger: Logger.new(io, level: Logger::WARN)))

    params = {from: 'Ruby', to: msisdn, text: "Unicode \u2713"}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    sms.send(params)

    assert_includes io.string, 'WARN -- : Sending unicode text SMS without setting the type parameter'
  end
end
