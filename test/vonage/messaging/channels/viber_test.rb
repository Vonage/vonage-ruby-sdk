# typed: false


class Vonage::Messaging::Channels::ViberTest < Vonage::Test
  def test_mms_initialize
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!')

    assert_kind_of Vonage::Messaging::Channels::Viber, viber
    assert_equal viber.data, { channel: ' viber_service', message_type: 'text', text: 'Hello world!' }
  end

  def test_with_valid_type_text_specified
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!')

    assert_equal 'text', viber.data[:message_type]
    assert_includes viber.data, :text
  end

  def test_with_valid_type_image_specified
    viber = Vonage::Messaging::Channels::Viber.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_equal 'image', viber.data[:message_type]
    assert_includes viber.data, :image
  end

  def test_with_invalid_type_specified
    exception = assert_raises {
      viber = Vonage::Messaging::Channels::Viber.new(type: 'audio', message: { url: 'https://example.com/audio.mp3' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid message type", exception.message
  end

  def test_with_valid_message_class
    viber = Vonage::Messaging::Channels::Viber.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_kind_of Hash, viber.data[:image]
  end

  def test_with_invalid_message_class
    exception = assert_raises {
      viber = Vonage::Messaging::Channels::Viber.new(type: 'image', message: "https://example.com/image.jpg")
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must be a Hash", exception.message
  end

  def test_image_without_url
    exception = assert_raises {
      viber = Vonage::Messaging::Channels::Viber.new(type: 'image', message: {})
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":url is required in :message", exception.message
  end

  def test_with_opts_client_ref
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!', opts: { client_ref: 'abc123' })

    assert_equal 'abc123', viber.data[:client_ref]
  end

  def test_with_opts_viber_service_object
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!', opts: { viber_service: { category: 'transaction', ttl: 600 } })

    assert_equal 'transaction', viber.data[:viber_service][:category]
    assert_equal 600, viber.data[:viber_service][:ttl]
  end
end
