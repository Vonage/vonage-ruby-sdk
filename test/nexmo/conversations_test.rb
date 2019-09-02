require_relative './test'

class NexmoConversationsTest < Nexmo::Test
  def conversations
    Nexmo::Conversations.new(config)
  end

  def conversations_uri
    'https://api.nexmo.com/beta/conversations'
  end

  def conversation_uri
    'https://api.nexmo.com/beta/conversations/' + conversation_id
  end

  def test_create_method
    params = {
      name: 'test_conversation',
      display_name: 'display_test_name'
    }

    stub_request(:post, conversations_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, conversations.create(params)
  end

  def test_list_method
    params = {status: 'completed'}

    stub_request(:get, conversations_uri).with(request(query: params)).to_return(response)

    assert_equal response_object, conversations.list(params)
  end

  def test_get_method
    stub_request(:get, conversation_uri).with(request).to_return(response)

    assert_equal response_object, conversations.get(conversation_id)
  end

  def test_update_method
    params = {
      name: 'test_conversation',
      display_name: 'display_test_name'
    }

    stub_request(:put, conversation_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, conversations.update(conversation_id, params)
  end

  def test_delete_method
    stub_request(:delete, conversation_uri).with(request).to_return(response)

    assert_equal response_object, conversations.delete(conversation_id)
  end

  def test_events_method
    assert_kind_of Nexmo::ConversationEvents, conversations.events
  end

  def test_legs_method
    assert_kind_of Nexmo::ConversationLegs, conversations.legs
  end

  def test_members_method
    assert_kind_of Nexmo::ConversationMembers, conversations.members
  end

  def test_users_method
    assert_kind_of Nexmo::ConversationUsers, conversations.users
  end
end
