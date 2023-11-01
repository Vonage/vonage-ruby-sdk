# typed: false
require_relative './test'

class Vonage::Verify2Test < Vonage::Test
  def verify2
    Vonage::Verify2.new(config)
  end

  def request_id
    'c11236f4-00bf-4b89-84ba-88b25df97315'
  end

  def response
    {
      headers: response_headers,
      body: '{"request_id":"c11236f4-00bf-4b89-84ba-88b25df97315"}'
    }
  end

  def uri
    'https://api.nexmo.com/v2/verify/'
  end

  def check_request_uri
    uri + request_id
  end

  def cancel_request_uri
    uri + request_id
  end

  def to_number
    '447700900000'
  end

  def brand
    'Example Brand'
  end

  def check_url
    'https://api.nexmo.com/v2/verify/c11236f4-00bf-4b89-84ba-88b25df97315/silent-auth/redirect'
  end

  def silent_auth_response
    {
      body: '{
        "request_id": "c11236f4-00bf-4b89-84ba-88b25df97315",
        "check_url": "https://api.nexmo.com/v2/verify/c11236f4-00bf-4b89-84ba-88b25df97315/silent-auth/redirect"
     }',
      headers: response_headers
    }
  end

  def test_start_verification_method
    workflow = [{channel: 'sms', to: to_number}]

    stub_request(:post, uri).with(body: {brand: brand, workflow: workflow}).to_return(response)

    assert_kind_of Vonage::Response, verify2.start_verification(brand: brand, workflow: workflow)
  end

  def test_start_verification_method_with_opts
    workflow = [{channel: 'sms', to: to_number}]
    opts = {locale: 'en-gb', channel_timeout: 200, client_ref: 'test-reference', code_length: 8}
    params = {brand: brand, workflow: workflow}.merge(opts)

    stub_request(:post, uri).with(body: params).to_return(response)

    assert_kind_of Vonage::Response, verify2.start_verification(brand: brand, workflow: workflow, **opts)
  end

  def test_start_verification_method_without_brand
    workflow = [{channel: 'sms', to: to_number}]

    assert_raises ArgumentError do
      verify2.start_verification(workflow: workflow)
    end
  end

  def test_start_verification_method_without_workflow
    assert_raises ArgumentError do
      verify2.start_verification(brand: brand)
    end
  end

  def test_start_verification_method_with_workflow_that_isnt_array
    workflow = {channel: 'sms', to: to_number}

    assert_raises ArgumentError do
      verify2.start_verification(brand: brand, workflow: workflow)
    end
  end

  def test_start_verification_method_with_empty_workflow
    assert_raises ArgumentError do
      verify2.start_verification(brand: brand, workflow: [])
    end
  end

  def test_start_verification_method_with_multiple_workflows
    workflow = [{channel: 'sms', to: to_number}, {channel: 'voice', to: to_number}]

    stub_request(:post, uri).with(body: {brand: brand, workflow: workflow}).to_return(response)

    assert_kind_of Vonage::Response, verify2.start_verification(brand: brand,workflow: workflow)
  end

  def test_start_verification_method_returns_check_url_with_silent_auth_workflow
    workflow = [{channel: 'silent_auth', to: to_number}]

    stub_request(:post, uri).with(body: {brand: brand, workflow: workflow}).to_return(silent_auth_response)
    verification_response = verify2.start_verification(brand: brand, workflow: workflow)

    assert_kind_of Vonage::Response, verification_response
    assert_equal check_url, verification_response.check_url
  end

  def test_check_code_method
    code = '1234'

    stub_request(:post, check_request_uri).with(body: {code: code}).to_return(status: 200, headers: {})

    assert_kind_of Vonage::Response, verify2.check_code(request_id: request_id, code: code)
  end

  def test_check_code_method_without_request_id
    assert_raises ArgumentError do
      verify2.check_code(code: '1234')
    end
  end

  def test_check_code_method_without_code
    assert_raises ArgumentError do
      verify2.check_code(request_id: request_id)
    end
  end

  def test_start_verification_options_method
    assert_instance_of Vonage::Verify2::StartVerificationOptions, verify2.start_verification_options
  end

  def test_start_verification_options_method_with_opts
    opts = {
      locale: 'en-gb',
      channel_timeout: 300,
      client_ref: 'foo',
      code_length: 6,
      code: 'abc123',
      fraud_check: false
    }

    verification_opts = verify2.start_verification_options(**opts)

    assert_instance_of Vonage::Verify2::StartVerificationOptions, verification_opts
    assert_equal opts[:locale], verification_opts.locale
    assert_equal opts[:channel_timeout], verification_opts.channel_timeout
    assert_equal opts[:client_ref], verification_opts.client_ref
    assert_equal opts[:code_length], verification_opts.code_length
    assert_equal opts[:code], verification_opts.code
    assert_equal opts[:fraud_check], verification_opts.fraud_check
  end

  def test_cancel_verification_request_method
    stub_request(:delete, cancel_request_uri).to_return(status: 204, headers: {})

    assert_kind_of Vonage::Response, verify2.cancel_verification_request(request_id: request_id)
  end

  def test_cancel_verification_request_method_without_request_id
    assert_raises ArgumentError do
      verify2.cancel_verification_request
    end
  end

  def test_workflow_method
    assert_instance_of Vonage::Verify2::Workflow, verify2.workflow
  end

  def test_workflow_builder_method
    assert_equal Vonage::Verify2::WorkflowBuilder, verify2.workflow_builder
  end
end
