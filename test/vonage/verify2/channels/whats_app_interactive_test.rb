# typed: false

class Vonage::Verify2::Channels::WhatsAppInteractiveTest < Vonage::Test
  def whatsapp_interactive_channel
    Vonage::Verify2::Channels::WhatsAppInteractive.new(to: e164_compliant_number)
  end

  def channel_getter_method
    assert_equal 'whatsapp_interactive', whatsapp_interactive_channel.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, whatsapp_interactive_channel.to
  end

  def test_to_setter_method
    channel = whatsapp_interactive_channel
    new_number = '447000000001'
    channel.to = new_number

    assert_equal new_number, channel.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      whatsapp_interactive_channel.to = invalid_number
    end
  end

  def test_to_h_method
    channel_hash = Vonage::Verify2::Channels::WhatsAppInteractive.new(to: e164_compliant_number).to_h

    assert_kind_of Hash, channel_hash
    assert_equal e164_compliant_number, channel_hash[:to]
  end
end
