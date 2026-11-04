# typed: false

class Vonage::Messaging::Channels::EmailTest < Vonage::Test
  def test_email_initialize
    email = Vonage::Messaging::Channels::Email.new(type: 'text', message: 'Hello world!', opts: { email: { subject: 'Hello' } })

    assert_kind_of Vonage::Messaging::Channels::Email, email
    assert_equal email.data, { channel: 'email', message_type: 'text', text: 'Hello world!', email: { subject: 'Hello' } }
  end

  def test_with_valid_type_text_specified
    email = Vonage::Messaging::Channels::Email.new(type: 'text', message: 'Hello world!', opts: { email: { subject: 'Hello' } })

    assert_equal 'text', email.data[:message_type]
    assert_includes email.data, :text
  end

  def test_with_valid_type_html_specified
    email = Vonage::Messaging::Channels::Email.new(type: 'html', message: { body: '<p>Hello world!</p>' }, opts: { email: { subject: 'Hello' } })

    assert_equal 'html', email.data[:message_type]
    assert_includes email.data, :html
  end

  def test_with_valid_type_content_specified
    email = Vonage::Messaging::Channels::Email.new(type: 'content', message: [{ type: 'text', text: 'Hello world!' }], opts: { email: { subject: 'Hello' } })

    assert_equal 'content', email.data[:message_type]
    assert_includes email.data, :content
  end

  def test_with_invalid_type_specified
    exception = assert_raises {
      Vonage::Messaging::Channels::Email.new(type: 'foo', message: 'bar')
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid message type", exception.message
  end

  def test_text_with_invalid_message_class
    exception = assert_raises {
      Vonage::Messaging::Channels::Email.new(type: 'text', message: {text: "Hello world!"}, opts: { email: { subject: 'Hello' } })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be a String", exception.message
  end

  def test_html_with_invalid_message_class
    exception = assert_raises {
      Vonage::Messaging::Channels::Email.new(type: 'html', message: "Hello world!", opts: { email: { subject: 'Hello' } })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be a Hash", exception.message
  end

  def test_content_with_invalid_message_class
    exception = assert_raises {
      Vonage::Messaging::Channels::Email.new(type: 'content', message: {text: "Hello world!"}, opts: { email: { subject: 'Hello' } })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid parameter type. `:message` must be an Array", exception.message
  end

  def test_content_with_invalid_array_contents
    exception = assert_raises {
      Vonage::Messaging::Channels::Email.new(type: 'content', message: ["Hello world!"], opts: { email: { subject: 'Hello' } })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Invalid array contents. Each element of `:message` must be a Hash", exception.message
  end

  def test_with_to_specified
    to_email = 'joe.bloggs@example.com'
    mms = Vonage::Messaging::Channels::Email.new(type: 'text', message: 'Hello world!', to: to_email, opts: { email: { subject: 'Hello' } })

    assert_equal to_email, mms.data[:to]
    assert_includes mms.data, :to
  end

  def test_with_from_specified
    from_email = 'no-reply@yourdomain.com'
    mms = Vonage::Messaging::Channels::Email.new(type: 'text', message: 'Hello world!', from: from_email, opts: { email: { subject: 'Hello' } })

    assert_equal from_email, mms.data[:from]
    assert_includes mms.data, :from
  end

  def test_with_to_and_from_specified
    to_email = 'joe.bloggs@example.com'
    from_email = 'no-reply@yourdomain.com'
    mms = Vonage::Messaging::Channels::Email.new(type: 'text', message: 'Hello world!', to: to_email, from: from_email, opts: { email: { subject: 'Hello' } })

    assert_equal to_email, mms.data[:to]
    assert_equal from_email, mms.data[:from]
    assert_includes mms.data, :to
    assert_includes mms.data, :from
  end

  def test_without_email_opts
    exception = assert_raises {
      Vonage::Messaging::Channels::Email.new(type: 'text', message: 'Hello world!', opts: { client_ref: 'abc123' })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Missing required parameter. `:email` is required in `:opts`", exception.message
  end

  def test_email_opts_without_subject
    exception = assert_raises {
      Vonage::Messaging::Channels::Email.new(type: 'text', message: 'Hello world!', opts: { email: { to_name: 'Joe Bloggs' } })
    }

    assert_instance_of Vonage::ClientError, exception
    assert_match "Missing required parameter. `:subject` is required in `:email`", exception.message  
  end
end
