# typed: false


class Vonage::Voice::Actions::ConversationTest < Vonage::Test
  def test_conversation_initialize
    conversation = Vonage::Voice::Actions::Conversation.new(name: 'test123')

    assert_kind_of Vonage::Voice::Actions::Conversation, conversation
    assert_equal conversation.name, 'test123'
  end

  def test_create_conversation
    expected = [{ action: 'conversation', name: 'test123' }]
    conversation = Vonage::Voice::Actions::Conversation.new(name: 'test123')

    assert_equal expected, conversation.create_conversation!(conversation)
  end

  def test_create_conversation_with_optional_params
    expected = [{ action: 'conversation', name: 'test123', startOnEnter: false }]
    conversation = Vonage::Voice::Actions::Conversation.new(name: 'test123', startOnEnter: false)

    assert_equal expected, conversation.create_conversation!(conversation)
  end

  def test_conversation_with_invalid_music_on_hold_url
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', musicOnHoldUrl: 'invalid') }

    assert_match "Invalid 'musicOnHoldUrl' value, must be a valid URL", exception.message
  end

  def test_conversation_with_invalid_start_on_enter
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', startOnEnter: 'yes') }

    assert_match "Expected 'startOnEnter' value to be a Boolean", exception.message
  end


  def test_conversation_with_invalid_end_on_exit
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', endOnExit: 'yes') }

    assert_match "Expected 'endOnExit' value to be a Boolean", exception.message
  end

  def test_conversation_with_invalid_record
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', record: 'yes') }

    assert_match "Expected 'record' value to be a Boolean", exception.message
  end

  def test_conversation_with_invalid_can_speak
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', canSpeak: 'yes') }
  
    assert_match "Expected 'canSpeak' value to be an Array of leg UUIDs", exception.message
  end

  def test_conversation_with_invalid_can_hear
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', canHear: 'yes') }

    assert_match "Expected 'canHear' value to be an Array of leg UUIDs", exception.message
  end

  def test_conversation_with_invalid_mute
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', mute: 'yes') }

    assert_match "Expected 'mute' value to be a Boolean", exception.message
  end

  def test_conversation_with_mute_and_can_speak
    exception = assert_raises { Vonage::Voice::Actions::Conversation.new(name: 'test123', mute: true, canSpeak: []) }

    assert_match "The 'mute' value is not supported if the 'canSpeak' option is defined", exception.message
  end
end