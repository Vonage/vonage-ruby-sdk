# typed: false

class Vonage::Verify2::Channels::SilentAuthTest < Vonage::Test
  def silent_auth_channel
    Vonage::Verify2::Channels::SilentAuth.new(to: e164_compliant_number)
  end

  def channel_getter_method
    assert_equal 'silent_auth', silent_auth_channel.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, silent_auth_channel.to
  end

  def test_to_setter_method
    channel = silent_auth_channel
    new_number = '447000000001'
    channel.to = new_number

    assert_equal new_number, channel.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      silent_auth_channel.to = invalid_number
    end
  end

  def test_to_h_method
    channel_hash = Vonage::Verify2::Channels::SilentAuth.new(to: e164_compliant_number).to_h

    assert_kind_of Hash, channel_hash
    assert_equal e164_compliant_number, channel_hash[:to]
  end
end
