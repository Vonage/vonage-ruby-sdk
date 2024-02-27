# typed: false
require_relative './test'

class Vonage::ConversationTest < Vonage::Test
  def conversation
    Vonage::Conversation.new(config)
  end

  def conversations_uri
    'https://api.nexmo.com/v1/conversations'
  end

  def conversation_uri
    'https://api.nexmo.com/v1/conversations/' + conversation_id
  end

  def test_user_method
    assert_kind_of Vonage::Conversation::User, conversation.user
  end

  def test_member_method
    assert_kind_of Vonage::Conversation::Member, conversation.member
  end

  def test_event_method
    assert_kind_of Vonage::Conversation::Event, conversation.event
  end
end
