# typed: false

class Vonage::Verify2::Channels::SMSTest < Vonage::Test
  def sms_channel
    Vonage::Verify2::Channels::SMS.new(to: e164_compliant_number)
  end

  def valid_android_app_hash
    'FA+9qCX9VSu'
  end

  def test_channel_getter_method
    assert_equal 'sms', sms_channel.channel
  end

  def test_with_to_omitted
    assert_raises(ArgumentError) { Vonage::Verify2::Channels::SMS.new }
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, sms_channel.to
  end

  def test_to_setter_method
    channel = sms_channel
    new_number = '447000000001'
    channel.to = new_number

    assert_equal new_number, channel.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_non_e164_compliant_number
    assert_raises ArgumentError do
      sms_channel.to = non_e164_compliant_number
    end
  end

  def test_from_getter_method
    assert_nil sms_channel.from
  end

  def test_from_setter_method_with_valid_numeric
    channel = sms_channel
    new_number = '447000000002'
    channel.from = new_number

    assert_equal new_number, channel.instance_variable_get(:@from)
  end

  def test_from_setter_method_with_valid_alphanumeric
    channel = sms_channel
    new_number = 'abc123'
    channel.from = new_number

    assert_equal new_number, channel.instance_variable_get(:@from)
  end

  def test_from_setter_method_with_numeric_too_short
    assert_raises ArgumentError do
      sms_channel.from = '4470000002'
    end
  end

  def test_from_setter_method_with_numeric_too_long
    assert_raises ArgumentError do
      sms_channel.from = '4470000000000002'
    end
  end

  def test_from_setter_method_with_alphanumeric_too_short
    assert_raises ArgumentError do
      sms_channel.from = 'ab'
    end
  end

  def test_from_setter_method_with_alphanumeric_too_long
    assert_raises ArgumentError do
      sms_channel.from = 'abcdefghijkl'
    end
  end

  def test_entity_id_getter_method
    assert_nil sms_channel.entity_id
  end

  def test_entity_id_setter_method
    channel = sms_channel
    channel.entity_id = '1101407360000017170'

    assert_equal '1101407360000017170', channel.instance_variable_get(:@entity_id)
  end

  def test_entity_id_setter_method_with_invalid_arg_too_short
    assert_raises ArgumentError do
      sms_channel.entity_id = ''
    end
  end

  def test_entity_id_setter_method_with_invalid_arg_too_long
    assert_raises ArgumentError do
      sms_channel.entity_id = '110140736000001717072'
    end
  end

  def test_content_id_getter_method
    assert_nil sms_channel.content_id
  end

  def test_content_id_setter_method
    channel = sms_channel
    channel.content_id = '1101407360000017170'

    assert_equal '1101407360000017170', channel.instance_variable_get(:@content_id)
  end

  def test_content_id_setter_method_with_invalid_arg_too_short
    assert_raises ArgumentError do
      sms_channel.content_id = ''
    end
  end

  def test_content_id_setter_method_with_invalid_arg_too_long
    assert_raises ArgumentError do
      sms_channel.content_id = '110140736000001717072'
    end
  end

  def test_app_hash_getter_method
    assert_nil sms_channel.app_hash
  end

  def test_app_hash_setter_method
    channel = sms_channel
    channel.app_hash = valid_android_app_hash

    assert_equal valid_android_app_hash, channel.instance_variable_get(:@app_hash)
  end

  def test_app_hash_setter_method_with_invalid_arg
    assert_raises ArgumentError do
      sms_channel.app_hash = valid_android_app_hash[0..8]
    end
  end

  def test_to_h_method
    channel_hash = Vonage::Verify2::Channels::SMS.new(
      to: e164_compliant_number,
      app_hash: valid_android_app_hash
    ).to_h

    assert_kind_of Hash, channel_hash
    assert_equal e164_compliant_number, channel_hash[:to]
    assert_equal valid_android_app_hash, channel_hash[:app_hash]
  end
end
