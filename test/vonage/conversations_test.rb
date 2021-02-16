# typed: false
require_relative './test'

class Vonage::ConversationsTest < Vonage::Test
  def conversations
    Vonage::Conversations.new(config)
  end

  def conversations_uri
    'https://api.nexmo.com/beta/conversations'
  end

  def conversation_uri
    'https://api.nexmo.com/beta/conversations/' + conversation_id
  end

  def conversation_record_uri
    'https://api.nexmo.com/v1/conversations/' + conversation_id + '/record'
  end

  def test_create_method
    params = {
      name: 'test_conversation',
      display_name: 'display_test_name'
    }

    stub_request(:post, conversations_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, conversations.create(params)
  end

  def test_list_method
    params = {status: 'completed'}

    stub_request(:get, conversations_uri).with(request(query: params)).to_return(response)

    response = conversations.list(params)

    response.each{|resp| assert_kind_of Vonage::Response, resp }
  end

  def test_list_pagination
    stub_request(:get, conversations_uri).with(request(query: { page_size: 1 })).to_return(
      { headers: response_headers, body: '{"page_size": 1, "record_index": 0, "count": 2, "_embedded": { "conversations": [{"uuid": "dummy-test-id-123"}] } }' }
    )

    stub_request(:get, conversations_uri).with(request(query: { page_size: 1, record_index: 1 })).to_return(
      { headers: response_headers, body: '{"page_size": 1, "record_index": 1, "count": 2, "_embedded": { "conversations": [{"uuid": "dummy-test-id-456"}] } }' }
    )
    response = conversations.list(page_size: 1)

    assert_equal(2, response._embedded.conversations.size)
  end

  def test_get_method
    stub_request(:get, conversation_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, conversations.get(conversation_id)
  end

  def test_update_method
    params = {
      name: 'test_conversation',
      display_name: 'display_test_name'
    }

    stub_request(:put, conversation_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, conversations.update(conversation_id, params)
  end

  def test_delete_method
    stub_request(:delete, conversation_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, conversations.delete(conversation_id)
  end

  def test_record_method
    params = {
      action: 'start',
      format: 'wav'
    }

    stub_request(:put, conversation_record_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, conversations.record(conversation_id, params)
  end

  def test_events_method
    assert_kind_of Vonage::Conversations::Events, conversations.events
  end

  def test_legs_method
    assert_kind_of Vonage::Conversations::Legs, conversations.legs
  end

  def test_members_method
    assert_kind_of Vonage::Conversations::Members, conversations.members
  end

  def test_users_method
    assert_kind_of Vonage::Conversations::Users, conversations.users
  end
end
