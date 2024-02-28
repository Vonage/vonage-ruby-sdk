# typed: false
require_relative '../test'

class Vonage::Conversation::UserTest < Vonage::Test
  def user
    Vonage::Conversation::User.new(config)
  end

  def user_uri
    'https://api.nexmo.com/v1/users/' + user_id
  end

  def test_list_conversations_method
    stub_request(:get, user_uri + '/conversations').to_return(conversation_list_response)
    user_conversations_list = user.list_conversations(user_id: user_id)

    assert_kind_of Vonage::Conversation::User::ConversationsListResponse, user_conversations_list
    user_conversations_list.each { |conversation| assert_kind_of Vonage::Entity, conversation }
  end

  def test_list_conversations_method_with_optional_params
    stub_request(:get, user_uri + '/conversations?order=asc&page_size=1').to_return(conversation_list_response)
    user_conversations_list = user.list_conversations(user_id: user_id, order: 'asc', page_size: 1)

    assert_kind_of Vonage::Conversation::User::ConversationsListResponse, user_conversations_list
    user_conversations_list.each { |conversation| assert_kind_of Vonage::Entity, conversation }
  end

  def test_list_conversations_method_without_user_id
    assert_raises(ArgumentError) { user.list_conversations }
  end

  def test_list_sessions_method
    stub_request(:get, user_uri + '/sessions').to_return(session_list_response)
    user_sessions_list = user.list_sessions(user_id: user_id)

    assert_kind_of Vonage::Conversation::User::SessionsListResponse, user_sessions_list
    user_sessions_list.each { |session| assert_kind_of Vonage::Entity, session }
  end

  def test_list_sessions_method_with_optional_params
    stub_request(:get, user_uri + '/sessions?order=asc&page_size=1').to_return(session_list_response)
    user_sessions_list = user.list_sessions(user_id: user_id, order: 'asc', page_size: 1)

    assert_kind_of Vonage::Conversation::User::SessionsListResponse, user_sessions_list
    user_sessions_list.each { |session| assert_kind_of Vonage::Entity, session }
  end

  def test_list_sessions_method_without_user_id
    assert_raises(ArgumentError) { user.list_sessions }
  end
end
