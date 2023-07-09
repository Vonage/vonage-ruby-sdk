# typed: false


class Vonage::Messaging::Channels::WhatsAppTest < Vonage::Test
  def test_messenger_initialize
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'text', message: 'Hello world!')

    assert_kind_of Vonage::Messaging::Channels::WhatsApp, whatsapp
    assert_equal whatsapp.data, { channel: 'whatsapp', message_type: 'text', text: 'Hello world!' }
  end

  def test_with_valid_type_text_specified
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'text', message: 'Hello world!')

    assert_equal 'text', whatsapp.data[:message_type]
    assert_includes whatsapp.data, :text
  end

  def test_with_valid_type_image_specified
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_equal 'image', whatsapp.data[:message_type]
    assert_includes whatsapp.data, :image
  end

  def test_with_valid_type_audio_specified
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'audio', message: { url: 'https://example.com/audio.mp3' })

    assert_equal 'audio', whatsapp.data[:message_type]
    assert_includes whatsapp.data, :audio
  end

  def test_with_valid_type_video_specified
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'video', message: { url: 'https://example.com/video.mp4' })

    assert_equal 'video', whatsapp.data[:message_type]
    assert_includes whatsapp.data, :video
  end

  def test_with_valid_type_file_specified
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'file', message: { url: 'https://example.com/file.pdf' })

    assert_equal 'file', whatsapp.data[:message_type]
    assert_includes whatsapp.data, :file
  end

  def test_with_valid_type_sticker_specified_with_url
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'sticker', message: { url: 'https://example.com/file.webp' })

    assert_equal 'sticker', whatsapp.data[:message_type]
    assert_includes whatsapp.data, :sticker
    assert_includes whatsapp.data[:sticker], :url
  end

  def test_with_valid_type_sticker_specified_with_id
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'sticker', message: { id: '16aec2a6-bf69-11ed-afa1-0242ac120002' })

    assert_equal 'sticker', whatsapp.data[:message_type]
    assert_includes whatsapp.data, :sticker
    assert_includes whatsapp.data[:sticker], :id
  end

  def test_with_invalid_type_specified
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'vcard', message: { url: 'https://example.com/contact.vcf' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid message type", exception.message
  end

  def test_with_valid_message_class
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_kind_of Hash, whatsapp.data[:image]
  end

  def test_with_invalid_message_class
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'image', message: "https://example.com/image.jpg")
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must be a Hash", exception.message
  end

  def test_object_message_without_url
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'image', message: {})
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":url is required in :message", exception.message
  end

  def test_template_message_without_name
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'template', message: {}, opts: { whatsapp: { policy: 'deterministic', locale: 'en-GB'} })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":name is required in :template", exception.message
  end

  def test_template_message_without_whatsapp_object
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'template', message: { name: 'verify'})
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":whatsapp is required in :opts", exception.message
  end

  def test_template_message_without_whatsapp_object_locale
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'template', message: { name: 'verify'}, opts: { whatsapp: { policy: 'deterministic'} })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":locale is required in :whatsapp", exception.message
  end

  def test_custom_message_with_invalid_message_type
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'custom', message: "Hello world!")
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must be a Hash", exception.message
  end

  def test_sticker_without_id_or_url
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'sticker', message: {})
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must contain either :id or :url", exception.message
  end

  def test_sticker_with_both_id_and_url
    exception = assert_raises {
      whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'sticker', message: { url: 'https://example.com/file.webp', id: '16aec2a6-bf69-11ed-afa1-0242ac120002' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must contain either :id or :url", exception.message
  end

  def test_with_opts_client_ref
    whatsapp = Vonage::Messaging::Channels::WhatsApp.new(type: 'text', message: 'Hello world!', opts: { client_ref: 'abc123' })

    assert_equal 'abc123', whatsapp.data[:client_ref]
  end
end
