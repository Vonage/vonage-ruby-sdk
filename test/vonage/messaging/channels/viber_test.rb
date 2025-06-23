# typed: false


class Vonage::Messaging::Channels::ViberTest < Vonage::Test
  def test_viber_initialize
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!')

    assert_kind_of Vonage::Messaging::Channels::Viber, viber
    assert_equal viber.data, { channel: 'viber_service', message_type: 'text', text: 'Hello world!' }
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

  def test_with_valid_type_video_specified
    viber = Vonage::Messaging::Channels::Viber.new(type: 'video', message: { url: 'https://example.com/video.mp4', thumb_url: 'https://example.com/file1.jpg' })

    assert_equal 'video', viber.data[:message_type]
    assert_includes viber.data, :video
  end

  def test_with_valid_type_file_specified
    viber = Vonage::Messaging::Channels::Viber.new(type: 'file', message: { url: 'https://example.com/file.pdf' })

    assert_equal 'file', viber.data[:message_type]
    assert_includes viber.data, :file
  end

  def test_with_invalid_type_specified
    exception = assert_raises {
      Vonage::Messaging::Channels::Viber.new(type: 'audio', message: { url: 'https://example.com/audio.mp3' })
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
      Vonage::Messaging::Channels::Viber.new(type: 'image', message: "https://example.com/image.jpg")
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must be a Hash", exception.message
  end

  def test_image_without_url
    exception = assert_raises {
      Vonage::Messaging::Channels::Viber.new(type: 'image', message: {})
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":url is required in :message", exception.message
  end

  def test_video_without_url
    exception = assert_raises {
      Vonage::Messaging::Channels::Viber.new(type: 'video', message: { thumb_url: 'https://example.com/file1.jpg' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":url is required in :message", exception.message
  end

  def test_video_without_thumb_url
    exception = assert_raises {
      Vonage::Messaging::Channels::Viber.new(type: 'video', message: { url: 'https://example.com/video.mp4' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":thumb_url is required in :message", exception.message
  end

  def test_file_without_url
    exception = assert_raises {
      Vonage::Messaging::Channels::Viber.new(type: 'file', message: {})
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

  def test_with_to_specified
    to_number = '447900000000'
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!', to: to_number)

    assert_equal to_number, viber.data[:to]
    assert_includes viber.data, :to
  end

  def test_with_from_specified
    from_number = '447900000001'
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!', from: from_number)

    assert_equal from_number, viber.data[:from]
    assert_includes viber.data, :from
  end

  def test_with_to_and_from_specified
    to_number = '447900000000'
    from_number = '447900000001'
    viber = Vonage::Messaging::Channels::Viber.new(type: 'text', message: 'Hello world!', to: to_number, from: from_number)

    assert_equal to_number, viber.data[:to]
    assert_equal from_number, viber.data[:from]
    assert_includes viber.data, :to
    assert_includes viber.data, :from
  end
end
