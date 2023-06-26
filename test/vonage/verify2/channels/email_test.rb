# typed: false

class Vonage::Verify2::Channels::EmailTest < Vonage::Test
  def email_channel
    Vonage::Verify2::Channels::Email.new(to: valid_email)
  end

  def valid_email
    'alice@example.com'
  end

  def channel_getter_method
    assert_equal 'whatsapp', email_channel.channel
  end

  def test_to_getter_method
    assert_equal valid_email, email_channel.to
  end

  def test_to_setter_method
    channel = email_channel
    new_email = 'bob@example.com'
    channel.to = new_email

    assert_equal new_email, channel.instance_variable_get(:@to)
  end

  def test_from_getter_method
    assert_nil email_channel.from
  end

  def test_from_setter_method
    channel = email_channel
    channel.from = valid_email

    assert_equal valid_email, channel.instance_variable_get(:@from)
  end

  def test_to_h_method
    channel_hash = Vonage::Verify2::Channels::Email.new(
      to: valid_email,
      from: valid_email
    ).to_h

    assert_kind_of Hash, channel_hash
    assert_equal valid_email, channel_hash[:to]
    assert_equal valid_email, channel_hash[:from]
  end
end
