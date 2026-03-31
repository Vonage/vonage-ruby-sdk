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
    assert_includes sms.data, :text
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

  def test_with_to_specified
    to_number = '447900000000'
    sms = Vonage::Messaging::Channels::SMS.new(message: 'Hello world!', to: to_number)

    assert_equal to_number, sms.data[:to]
    assert_includes sms.data, :to
  end

  def test_with_from_specified
    from_number = '447900000001'
    sms = Vonage::Messaging::Channels::SMS.new(message: 'Hello world!', from: from_number)

    assert_equal from_number, sms.data[:from]
    assert_includes sms.data, :from
  end

  def test_with_to_and_from_specified
    to_number = '447900000000'
    from_number = '447900000001'
    sms = Vonage::Messaging::Channels::SMS.new(message: 'Hello world!', to: to_number, from: from_number)

    assert_equal to_number, sms.data[:to]
    assert_equal from_number, sms.data[:from]
    assert_includes sms.data, :to
    assert_includes sms.data, :from
  end

  def test_with_opts
    sms = Vonage::Messaging::Channels::SMS.new(type: 'text', message: 'Hello world!', opts: { client_ref: 'abc123' })

    assert_equal 'abc123', sms.data[:client_ref]
  end
end
