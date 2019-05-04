require_relative './test'

class NexmoConversationEventsTest < Nexmo::Test
  def events
    Nexmo::ConversationEvents.new(client)
  end

  def event_id
    1
  end

  def member_id
    'MEM-xxxxxx'
  end

  def events_uri
    "https://api.nexmo.com/beta/conversations/#{conversation_id}/events"
  end

  def event_uri
    "https://api.nexmo.com/beta/conversations/#{conversation_id}/events/#{event_id}"
  end

  def test_create_method
    params = {type: 'text', from: member_id}

    request_stub = stub_request(:post, events_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, events.create(conversation_id, params)
    assert_requested request_stub
  end

  def test_list_method
    request_stub = stub_request(:get, events_uri).with(request).to_return(response)

    assert_equal response_object, events.list(conversation_id)
    assert_requested request_stub
  end

  def test_get_method
    request_stub = stub_request(:get, event_uri).with(request).to_return(response)

    assert_equal response_object, events.get(conversation_id, event_id)
    assert_requested request_stub
  end

  def test_delete_method
    request_stub = stub_request(:delete, event_uri).with(request).to_return(response)

    assert_equal response_object, events.delete(conversation_id, event_id)
    assert_requested request_stub
  end
end
