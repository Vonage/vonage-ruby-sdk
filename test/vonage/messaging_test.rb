# typed: false
require_relative './test'

class Vonage::MessagingTest < Vonage::Test
  def messaging
    Vonage::Messaging.new(config)
  end

  def geo_specific_messaging_host
    'api-eu.vonage.com'
  end

  def geo_specific_messaging
    Vonage::Messaging.new(config.merge(api_host: geo_specific_messaging_host))
  end

  def messaging_uri
    'https://api.nexmo.com/v1/messages'
  end

  def test_valid_message_delegator
    message = Vonage::Messaging::Message.sms(message: "Hello world!")
    assert_equal message, messaging.sms(message: "Hello world!")
  end

  def test_invalid_message_delegator
    assert_raises { messaging.invalid }
  end

  def test_send_method
    params = {
      to: "447700900000",
      from: "447700900001",
      channel: "sms",
      message_type: "text",
      text: "Hello world!"
    }

    stub_request(:post, messaging_uri).with(request(body: params)).to_return(response)

    message = messaging.sms(message: "Hello world!")

    assert_kind_of Vonage::Response, messaging.send(to: "447700900000", from: "447700900001", **message)
  end

  def test_send_method_without_to
    assert_raises(ArgumentError) { messaging.send(from: "447700900001", channel: 'sms', message_type: 'text', text: "Hello world!") }
  end

  def test_send_method_without_from
    assert_raises(ArgumentError) { messaging.send(to: "447700900000", channel: 'sms', message_type: 'text', text: "Hello world!") }
  end

  def test_send_method_without_channel
    assert_raises(ArgumentError) { messaging.send(to: "447700900000", from: "447700900001", message_type: 'text', text: "Hello world!") }
  end

  def test_send_method_without_message_type
    assert_raises(ArgumentError) { messaging.send(to: "447700900000", from: "447700900001", channel: 'sms', text: "Hello world!") }
  end

  def test_verify_webhook_token_method_with_valid_secret_passed_in
    verification = messaging.verify_webhook_token(token: sample_webhook_token, signature_secret: sample_valid_signature_secret)

    assert_equal(true, verification)
  end

  def test_verify_webhook_token_method_with_valid_secret_in_config
    config.signature_secret = sample_valid_signature_secret
    verification = messaging.verify_webhook_token(token: sample_webhook_token)

    assert_equal(true, verification)
  end

  def test_verify_webhook_token_method_with_invalid_secret
    verification = messaging.verify_webhook_token(token: sample_webhook_token, signature_secret: sample_invalid_signature_secret)

    assert_equal(false, verification)
  end

  def test_verify_webhook_token_method_with_no_token
    assert_raises(ArgumentError) { messaging.verify_webhook_token }
  end

  def test_update_method
    stub_request(:patch, 'https://' + geo_specific_messaging_host + '/v1/messages/' + message_uuid).with(request(body: {status: 'read'})).to_return(response)

    assert_kind_of Vonage::Response, geo_specific_messaging.update(message_uuid: message_uuid, status: 'read')
  end
end
