require_relative './test'

class NexmoConversationMembersTest < Nexmo::Test
  def members
    Nexmo::ConversationMembers.new(config)
  end

  def user_id
    'USR-xxxxxx'
  end

  def member_id
    'MEM-xxxxxx'
  end

  def members_uri
    "https://api.nexmo.com/beta/conversations/#{conversation_id}/members"
  end

  def member_uri
    "https://api.nexmo.com/beta/conversations/#{conversation_id}/members/#{member_id}"
  end

  def params
    {
      action: 'invite',
      user_id: user_id,
      channel: {
        type: 'phone',
        to: {
          type: 'phone',
          number: msisdn
        }
      }
    }
  end

  def test_create_method
    stub_request(:post, members_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, members.create(conversation_id, params)
  end

  def test_list_method
    stub_request(:get, members_uri).with(request).to_return(response)

    assert_equal response_object, members.list(conversation_id)
  end

  def test_get_method
    stub_request(:get, member_uri).with(request).to_return(response)

    assert_equal response_object, members.get(conversation_id, member_id)
  end

  def test_update_method
    stub_request(:put, member_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, members.update(conversation_id, member_id, params)
  end

  def test_delete_method
    stub_request(:delete, member_uri).with(request).to_return(response)

    assert_equal response_object, members.delete(conversation_id, member_id)
  end
end
