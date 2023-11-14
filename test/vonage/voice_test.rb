# typed: false
require_relative './test'

class Vonage::VoiceTest < Vonage::Test
  def calls
    Vonage::Voice.new(config)
  end

  def calls_uri
    'https://api.nexmo.com/v1/calls'
  end

  def call_uri
    'https://api.nexmo.com/v1/calls/' + call_uuid
  end

  def test_create_method
    params = {
      to: [{type: 'phone', number: '14843331234'}],
      from: {type: 'phone', number: '14843335555'},
      answer_url: ['https://example.com/answer']
    }

    stub_request(:post, calls_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.create(params)
  end

  def test_create_method_raises_error_if_from_set_and_random_from_number_true
    params = {
      to: [{type: 'phone', number: '14843331234'}],
      from: {type: 'phone', number: '14843335555'},
      random_from_number: true,
      answer_url: ['https://example.com/answer']
    }

    exception = assert_raises {
      calls.create(params)
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "`from` should not be set if `random_from_number` is `true`", exception.message
  end

  def test_create_method_sets_random_from_number_to_true_if_from_not_set
    input_params = {
      to: [{type: 'phone', number: '14843331234'}],
      answer_url: ['https://example.com/answer']
    }

    request_params = {
      to: [{type: 'phone', number: '14843331234'}],
      random_from_number: true,
      answer_url: ['https://example.com/answer']
    }

    stub_request(:post, calls_uri).with(request(body: request_params)).to_return(response)

    assert_kind_of Vonage::Response, calls.create(input_params)
  end

  def test_list_method
    params = {status: 'completed'}

    stub_request(:get, calls_uri).with(request(query: params)).to_return(voice_response)

    response = calls.list(params)

    response.each{|resp| assert_kind_of Vonage::Voice::ListResponse, resp }
  end

  def test_get_method
    stub_request(:get, call_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, calls.get(call_uuid)
  end

  def test_update_method
    params = {action: 'hangup'}

    stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.update(call_uuid, params)
  end

  def test_hangup_method
    params = {action: 'hangup'}

    stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.hangup(call_uuid)
  end

  def test_mute_method
    params = {action: 'mute'}

    stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.mute(call_uuid)
  end

  def test_unmute_method
    params = {action: 'unmute'}

    stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.unmute(call_uuid)
  end

  def test_earmuff_method
    params = {action: 'earmuff'}

    stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.earmuff(call_uuid)
  end

  def test_unearmuff_method
    params = {action: 'unearmuff'}

    stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.unearmuff(call_uuid)
  end

  def test_transfer_method
    destination = {type: 'ncco', url: ['http://example.org/new-ncco.json']}

    params = {action: 'transfer', destination: destination}

    stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, calls.transfer(call_uuid, destination: destination)
  end

  def test_stream_method
    assert_kind_of Vonage::Voice::Stream, calls.stream
  end

  def test_talk_method
    assert_kind_of Vonage::Voice::Talk, calls.talk
  end

  def test_dtmf_method
    assert_kind_of Vonage::Voice::DTMF, calls.dtmf
  end

  def test_verify_webhook_token_method_with_valid_secret_passed_in
    verification = calls.verify_webhook_token(token: sample_webhook_token, signature_secret: sample_valid_signature_secret)

    assert_equal(true, verification)
  end

  def test_verify_webhook_token_method_with_valid_secret_in_config
    config.signature_secret = sample_valid_signature_secret
    verification = calls.verify_webhook_token(token: sample_webhook_token)

    assert_equal(true, verification)
  end

  def test_verify_webhook_token_method_with_invalid_secret
    verification = calls.verify_webhook_token(token: sample_webhook_token, signature_secret: sample_invalid_signature_secret)

    assert_equal(false, verification)
  end

  def test_verify_webhook_token_method_with_no_token
    assert_raises(ArgumentError) { calls.verify_webhook_token }
  end
end
