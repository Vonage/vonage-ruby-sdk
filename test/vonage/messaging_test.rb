# typed: false
require_relative './test'

class Vonage::MessagingTest < Vonage::Test
  def messaging
    Vonage::Messaging.new(config)
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

    message = Vonage::Messaging::Message.sms(message: "Hello world!")

    assert_kind_of Vonage::Response, messaging.send(to: "447700900000", from: "447700900001", **message)
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
end
