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
end