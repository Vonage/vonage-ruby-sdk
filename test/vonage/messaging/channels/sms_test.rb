# typed: false


class Vonage::Messaging::Channels::SMSTest < Vonage::Test
  def test_sms_initialize
    sms = Vonage::Messaging::Channels::SMS.new(message: 'Hello world!')

    assert_kind_of Vonage::Messaging::Channels::SMS, sms
    assert_equal sms.data, { channel: 'sms', message_type: 'text', text: 'Hello world!' }
  end

  def test_with_valid_type_specified
    sms = Vonage::Messaging::Channels::SMS.new(type: 'text', message: 'Hello world!')

    assert_equal 'text', sms.data[:message_type]
  end

  def test_with_invalid_type_specified
    exception = assert_raises {
      Vonage::Messaging::Channels::SMS.new(type: 'image', message: 'Hello world!')
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid message type", exception.message
  end

  def test_with_valid_message_class
    sms = Vonage::Messaging::Channels::SMS.new(type: 'text', message: 'Hello world!')

    assert_kind_of String, sms.data[:text]
  end

  def test_with_invalid_message_class
    exception = assert_raises {
      Vonage::Messaging::Channels::SMS.new(type: 'text', message: {text: 'Hello world!'} )
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must be a String", exception.message
  end

  def test_with_opts
    sms = Vonage::Messaging::Channels::SMS.new(type: 'text', message: 'Hello world!', opts: { client_ref: 'abc123' })

    assert_equal 'abc123', sms.data[:client_ref]
  end
end
