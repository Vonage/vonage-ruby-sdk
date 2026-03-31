# typed: false


class Vonage::Messaging::Channels::MessengerTest < Vonage::Test
  def test_messenger_initialize
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'text', message: 'Hello world!')

    assert_kind_of Vonage::Messaging::Channels::Messenger, messenger
    assert_equal messenger.data, { channel: 'messenger', message_type: 'text', text: 'Hello world!' }
  end

  def test_with_valid_type_text_specified
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'text', message: 'Hello world!')

    assert_equal 'text', messenger.data[:message_type]
    assert_includes messenger.data, :text
  end

  def test_with_valid_type_image_specified
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_equal 'image', messenger.data[:message_type]
    assert_includes messenger.data, :image
  end

  def test_with_valid_type_audio_specified
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'audio', message: { url: 'https://example.com/audio.mp3' })

    assert_equal 'audio', messenger.data[:message_type]
    assert_includes messenger.data, :audio
  end

  def test_with_valid_type_video_specified
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'video', message: { url: 'https://example.com/video.mp4' })

    assert_equal 'video', messenger.data[:message_type]
    assert_includes messenger.data, :video
  end

  def test_with_valid_type_file_specified
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'file', message: { url: 'https://example.com/file.pdf' })

    assert_equal 'file', messenger.data[:message_type]
    assert_includes messenger.data, :file
  end

  def test_with_invalid_type_specified
    exception = assert_raises {
      Vonage::Messaging::Channels::Messenger.new(type: 'vcard', message: { url: 'https://example.com/contact.vcf' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid message type", exception.message
  end

  def test_with_valid_message_class
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_kind_of Hash, messenger.data[:image]
  end

  def test_with_invalid_message_class
    exception = assert_raises {
      Vonage::Messaging::Channels::Messenger.new(type: 'image', message: "https://example.com/image.jpg")
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must be a Hash", exception.message
  end

  def test_object_message_without_url
    exception = assert_raises {
      Vonage::Messaging::Channels::Messenger.new(type: 'image', message: {})
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":url is required in :message", exception.message
  end

  def test_with_opts_client_ref
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'text', message: 'Hello world!', opts: { client_ref: 'abc123' })

    assert_equal 'abc123', messenger.data[:client_ref]
  end

  def test_with_opts_messenger_object
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'text', message: 'Hello world!', opts: { messenger: { category: 'response', tag: 'CONFIRMED_EVENT_UPDATE' } })

    assert_equal 'response', messenger.data[:messenger][:category]
    assert_equal 'CONFIRMED_EVENT_UPDATE', messenger.data[:messenger][:tag]
  end

  def test_with_to_specified
    to_number = '447900000000'
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'text', message: 'Hello world!', to: to_number)

    assert_equal to_number, messenger.data[:to]
    assert_includes messenger.data, :to
  end

  def test_with_from_specified
    from_number = '447900000001'
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'text', message: 'Hello world!', from: from_number)

    assert_equal from_number, messenger.data[:from]
    assert_includes messenger.data, :from
  end

  def test_with_to_and_from_specified
    to_number = '447900000000'
    from_number = '447900000001'
    messenger = Vonage::Messaging::Channels::Messenger.new(type: 'text', message: 'Hello world!', to: to_number, from: from_number)

    assert_equal to_number, messenger.data[:to]
    assert_equal from_number, messenger.data[:from]
    assert_includes messenger.data, :to
    assert_includes messenger.data, :from
  end
end
