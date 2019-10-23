# typed: false
require_relative '../test'

class Vonage::Conversations::EventsTest < Vonage::Test
  def events
    Vonage::Conversations::Events.new(config)
  end

  def event_id
    1
  end

  def events_uri
    "https://api.nexmo.com/v0.1/conversations/#{conversation_id}/events"
  end

  def event_uri
    "https://api.nexmo.com/v0.1/conversations/#{conversation_id}/events/#{event_id}"
  end

  def test_create_method
    params = {type: 'text', from: member_id}

    stub_request(:post, events_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, events.create(conversation_id, params)
  end

  def test_create_method_with_error
    params = {type: 'invalid', from: 'invalid-member'}

    stub_request(:post, events_uri).with(request(body: params)).to_return(error_response)

    assert_raises Vonage::ClientError do
      events.create(conversation_id, params)
    end
  end

  def test_list_method
    stub_request(:get, events_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, events.list(conversation_id)
  end

  def test_get_method
    stub_request(:get, event_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, events.get(conversation_id, event_id)
  end

  def test_delete_method
    stub_request(:delete, event_uri).with(request).to_return(response)

    assert_kind_of Vonage::Response, events.delete(conversation_id, event_id)
  end
end
