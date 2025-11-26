# typed: false


class Vonage::Voice::Actions::TransferTest < Vonage::Test
  def test_transfer_initialize
    transfer = Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id)

    assert_kind_of Vonage::Voice::Actions::Transfer, transfer
  end

  def test_create_transfer
    expected = [{ action: 'transfer', conversation_id: conversation_id }]
    transfer = Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id)

    assert_equal expected, transfer.create_transfer!(transfer)
  end

  def test_create_transfer_with_optional_params
    expected = [{ action: 'transfer', conversation_id: conversation_id, canHear: [conversation_leg_uuid], canSpeak: [conversation_leg_uuid] }]
    transfer = Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, can_hear: [conversation_leg_uuid], can_speak: [conversation_leg_uuid])

    assert_equal expected, transfer.create_transfer!(transfer)
  end

  def test_create_transfer_with_mute_option_set_to_true
    expected = [{ action: 'transfer', conversation_id: conversation_id, mute: true }]
    transfer = Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, mute: true)

    assert_equal expected, transfer.create_transfer!(transfer)
  end

  def test_create_transfer_with_mute_option_set_to_false
    expected = [{ action: 'transfer', conversation_id: conversation_id, mute: false }]
    transfer = Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, mute: false)

    assert_equal expected, transfer.create_transfer!(transfer)
  end

  def test_transfer_with_invalid_conversation_id
    exception = assert_raises { Vonage::Voice::Actions::Transfer.new(conversation_id: 123) }

    assert_match "Expected 'conversation_id' parameter to be a string", exception.message
  end

  def test_transfer_with_invalid_can_hear_type
    exception = assert_raises { Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, can_hear: conversation_leg_uuid) }

    assert_match "Expected 'can_hear' parameter to be an array of strings", exception.message
  end

  def test_transfer_with_invalid_can_hear_contents
    exception = assert_raises { Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, can_hear: [123]) }

    assert_match "Expected 'can_hear' parameter to be an array of strings", exception.message
  end

  def test_transfer_with_invalid_can_speak_type
    exception = assert_raises { Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, can_speak: conversation_leg_uuid) }

    assert_match "Expected 'can_speak' parameter to be an array of strings", exception.message
  end

  def test_transfer_with_invalid_can_speak_contents
    exception = assert_raises { Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, can_speak: [123]) }

    assert_match "Expected 'can_speak' parameter to be an array of strings", exception.message
  end

  def test_transfer_with_invalid_mute_type
    exception = assert_raises { Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, mute: 'true') }

    assert_match "Expected 'mute' parameter to be a boolean", exception.message
  end

  def test_transfer_with_invalid_mute_combination
    exception = assert_raises { Vonage::Voice::Actions::Transfer.new(conversation_id: conversation_id, can_speak: [conversation_leg_uuid], mute: true) }

    assert_match "The 'mute' parameter is not supported if 'can_speak' is also set", exception.message
  end
end