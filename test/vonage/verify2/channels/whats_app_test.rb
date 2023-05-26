# typed: false

class Vonage::Verify2::Channels::WhatsAppTest < Vonage::Test
  def whatsapp_channel
    Vonage::Verify2::Channels::WhatsApp.new(to: e164_compliant_number)
  end

  def channel_getter_method
    assert_equal 'whatsapp', whatsapp_channel.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, whatsapp_channel.to
  end

  def test_to_setter_method
    channel = whatsapp_channel
    new_number = '447000000001'
    channel.to = new_number

    assert_equal new_number, channel.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      whatsapp_channel.to = invalid_number
    end
  end

  def test_from_getter_method
    assert_nil whatsapp_channel.from
  end

  def test_from_setter_method
    channel = whatsapp_channel
    channel.from = e164_compliant_number

    assert_equal e164_compliant_number, channel.instance_variable_get(:@from)
  end

  def test_from_setter_method_with_invalid_arg
    assert_raises ArgumentError do
      whatsapp_channel.from = invalid_number
    end
  end

  def test_to_h_method
    channel_hash = Vonage::Verify2::Channels::WhatsApp.new(
      to: e164_compliant_number,
      from: e164_compliant_number
    ).to_h

    assert_kind_of Hash, channel_hash
    assert_equal e164_compliant_number, channel_hash[:to]
    assert_equal e164_compliant_number, channel_hash[:from]
  end
end
