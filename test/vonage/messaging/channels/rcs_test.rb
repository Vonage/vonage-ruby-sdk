# typed: false


class Vonage::Messaging::Channels::RCSTest < Vonage::Test
  def test_rcs_initialize
    message = Vonage::Messaging::Channels::RCS.new(type: 'text', message: 'Hello world!')

    assert_kind_of Vonage::Messaging::Channels::RCS, message
  end

  def test_rcs_text_message
    expected = {
      channel: 'rcs',
      message_type: 'text',
      text: 'Hello world!'
    }

    message = Vonage::Messaging::Channels::RCS.new(
      type: 'text',
      message: 'Hello world!'
    )

    assert_equal expected, message.data
  end

  def test_rcs_text_message_wth_optional_parameters
    expected = {
      channel: 'rcs',
      message_type: 'text',
      text: 'Hello world!',
      ttl: 600,
      client_ref: "abc123",
      webhook_url: "https://example.com/status",
      rcs: {
        category: 'transaction'
      }
    }

    message = Vonage::Messaging::Channels::RCS.new(
      type: 'text',
      message: 'Hello world!',
      opts: {
        ttl: 600,
        client_ref: "abc123",
        webhook_url: "https://example.com/status",
        rcs: {
          category: 'transaction'
        }
      }
    )

    assert_equal expected, message.data
  end

  def test_rcs_image_message
    expected = {
      channel: 'rcs',
      message_type: 'image',
      image: {
        url: 'https://example.com/image.jpg'
      }
    }

    message = Vonage::Messaging::Channels::RCS.new(
      type: 'image',
      message: {
        url: 'https://example.com/image.jpg'
      }
    )

    assert_equal expected, message.data
  end

  def test_rcs_video_message
    expected = {
      channel: 'rcs',
      message_type: 'image',
      image: {
        url: 'https://example.com/video.webm'
      }
    }

    message = Vonage::Messaging::Channels::RCS.new(
      type: 'image',
      message: {
        url: 'https://example.com/video.webm'
      }
    )

    assert_equal expected, message.data
  end

  def test_rcs_file_message
    expected = {
      channel: 'rcs',
      message_type: 'file',
      file: {
        url: 'https://example.com/file.pdf'
      }
    }

    message = Vonage::Messaging::Channels::RCS.new(
      type: 'file',
      message: {
        url: 'https://example.com/file.pdf'
      }
    )

    assert_equal expected, message.data
  end

  def test_rcs_custom_message
    expected = {
      channel: 'rcs',
      message_type: 'custom',
      custom: {
        contentMessage: {
          text: 'Which ice-cream flavour do you prefer?',
          suggestions: [
            {
              reply: {
                text: 'Vanilla',
                postback: 'vanilla'
              }
            },
            {
              reply: {
                text: 'Chocolate',
                postback: 'chocolate'
              }
            }
          ]
        }
      }
    }

    message = Vonage::Messaging::Channels::RCS.new(
      type: 'custom',
      message: {
        contentMessage: {
          text: 'Which ice-cream flavour do you prefer?',
          suggestions: [
            {
              reply: {
                text: 'Vanilla',
                postback: 'vanilla'
              }
            },
            {
              reply: {
                text: 'Chocolate',
                postback: 'chocolate'
              }
            }
          ]
        }
      }
    )

    assert_equal expected, message.data
  end

  def test_rcs_invalid_message_type
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'invalid', message: 'Hello world!') }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid message type", exception.message
  end

  def test_rcs_text_message_invalid_type
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'text', message: 123) }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be a String", exception.message
  end

  def test_rcs_image_message_invalid_type
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'image', message: 'https://example.com/image.jpg') }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be a Hash", exception.message
  end

  def test_rcs_image_message_missing_url
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'image', message: {}) }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Missing parameter. `:message` must contain a `:url` key", exception.message
  end

  def test_rcs_video_message_invalid_type
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'video', message: 'https://example.com/video.webm') }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be a Hash", exception.message
  end

  def test_rcs_video_message_missing_url
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'video', message: {}) }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Missing parameter. `:message` must contain a `:url` key", exception.message
  end

  def test_rcs_file_message_invalid_type
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'file', message: 'https://example.com/file.pdf') }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be a Hash", exception.message
  end

  def test_rcs_file_message_missing_url
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'file', message: {}) }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Missing parameter. `:message` must contain a `:url` key", exception.message
  end

  def test_rcs_custom_message_invalid_type
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'custom', message: 'Hello world!') }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be a Hash", exception.message
  end

  def test_rcs_custom_message_with_empty_message_hash
    exception = assert_raises { Vonage::Messaging::Channels::RCS.new(type: 'custom', message: {}) }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter content. `:message` must not be empty", exception.message
  end

  def test_with_to_specified
    to_number = '447900000000'
    rcs = Vonage::Messaging::Channels::RCS.new(type: 'text', message: 'Hello world!', to: to_number)

    assert_equal to_number, rcs.data[:to]
    assert_includes rcs.data, :to
  end

  def test_with_from_specified
    from_number = '447900000001'
    rcs = Vonage::Messaging::Channels::RCS.new(type: 'text', message: 'Hello world!', from: from_number)

    assert_equal from_number, rcs.data[:from]
    assert_includes rcs.data, :from
  end

  def test_with_to_and_from_specified
    to_number = '447900000000'
    from_number = '447900000001'
    rcs = Vonage::Messaging::Channels::RCS.new(type: 'text', message: 'Hello world!', to: to_number, from: from_number)

    assert_equal to_number, rcs.data[:to]
    assert_equal from_number, rcs.data[:from]
    assert_includes rcs.data, :to
    assert_includes rcs.data, :from
  end
end
