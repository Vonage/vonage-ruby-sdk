# typed: false


class Vonage::Messaging::Channels::MMSTest < Vonage::Test
  def test_mms_initialize
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_kind_of Vonage::Messaging::Channels::MMS, mms
    assert_equal mms.data, { channel: 'mms', message_type: 'image', image: { url: 'https://example.com/image.jpg' } }
  end

  def test_with_valid_type_image_specified
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_equal 'image', mms.data[:message_type]
    assert_includes mms.data, :image
  end

  def test_with_valid_type_vcard_specified
    mms = Vonage::Messaging::Channels::MMS.new(type: 'vcard', message: { url: 'https://example.com/contact.vcf' })

    assert_equal 'vcard', mms.data[:message_type]
    assert_includes mms.data, :vcard
  end

  def test_with_valid_type_audio_specified
    mms = Vonage::Messaging::Channels::MMS.new(type: 'audio', message: { url: 'https://example.com/audio.mp3' })

    assert_equal 'audio', mms.data[:message_type]
    assert_includes mms.data, :audio
  end

  def test_with_valid_type_video_specified
    mms = Vonage::Messaging::Channels::MMS.new(type: 'video', message: { url: 'https://example.com/video.mp4' })

    assert_equal 'video', mms.data[:message_type]
    assert_includes mms.data, :video
  end

  def test_with_invalid_type_specified
    exception = assert_raises {
      Vonage::Messaging::Channels::MMS.new(type: 'text', message: { url: 'https://example.com/video.mp4' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid message type", exception.message
  end

  def test_with_valid_message_class
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg' })

    assert_kind_of Hash, mms.data[:image]
  end

  def test_with_invalid_message_class
    exception = assert_raises {
      Vonage::Messaging::Channels::MMS.new(type: 'image', message: "https://example.com/image.jpg")
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":message must be a Hash", exception.message
  end

  def test_with_caption
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg', caption: "Additional text to accompany the image." })

    assert_includes mms.data[:image], :caption
    assert_equal "Additional text to accompany the image.", mms.data[:image][:caption]
  end

  def test_without_url
    exception = assert_raises {
      Vonage::Messaging::Channels::MMS.new(type: 'image', message: { caption: "Additional text to accompany the image." })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match ":url is required in :message", exception.message
  end

  def test_with_to_specified
    to_number = '447900000000'
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg' }, to: to_number)

    assert_equal to_number, mms.data[:to]
    assert_includes mms.data, :to
  end

  def test_with_from_specified
    from_number = '447900000001'
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg' }, from: from_number)

    assert_equal from_number, mms.data[:from]
    assert_includes mms.data, :from
  end

  def test_with_to_and_from_specified
    to_number = '447900000000'
    from_number = '447900000001'
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg' }, to: to_number, from: from_number)

    assert_equal to_number, mms.data[:to]
    assert_equal from_number, mms.data[:from]
    assert_includes mms.data, :to
    assert_includes mms.data, :from
  end

  def test_with_opts
    mms = Vonage::Messaging::Channels::MMS.new(type: 'image', message: { url: 'https://example.com/image.jpg' }, opts: { client_ref: 'abc123' })

    assert_equal 'abc123', mms.data[:client_ref]
  end
end
