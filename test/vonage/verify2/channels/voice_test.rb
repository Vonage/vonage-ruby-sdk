# typed: false

class Vonage::Verify2::Channels::VoiceTest < Vonage::Test
  def voice_channel
    Vonage::Verify2::Channels::Voice.new(to: e164_compliant_number)
  end

  def test_channel_getter_method
    assert_equal 'voice', voice_channel.channel
  end

  def test_with_to_omitted
    assert_raises(ArgumentError) { Vonage::Verify2::Channels::Voice.new }
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, voice_channel.to
  end

  def test_to_setter_method
    channel = voice_channel
    new_number = '447000000001'
    channel.to = new_number

    assert_equal new_number, channel.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_non_e164_compliant_number
    assert_raises ArgumentError do
      voice_channel.to = non_e164_compliant_number
    end
  end

  def test_to_h_method
    channel_hash = Vonage::Verify2::Channels::Voice.new(to: e164_compliant_number).to_h

    assert_kind_of Hash, channel_hash
    assert_equal e164_compliant_number, channel_hash[:to]
  end
end
