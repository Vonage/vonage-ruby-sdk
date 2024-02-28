# typed: false
require_relative '../test'

class Vonage::Conversation::EventTest < Vonage::Test
  def event
    Vonage::Conversation::Event.new(config)
  end

  def event_id
    1
  end

  def events_uri
    "https://api.nexmo.com/v1/conversations/#{conversation_id}/events"
  end

  def event_uri
    "https://api.nexmo.com/v1/conversations/#{conversation_id}/events/#{event_id}"
  end

  def test_list_method
    stub_request(:get, events_uri).to_return(events_list_response)

    events_list = event.list(conversation_id: conversation_id)

    assert_kind_of Vonage::Conversation::Event::ListResponse, events_list
    events_list.each { |event| assert_kind_of Vonage::Entity, event }
  end

  def test_list_method_with_optional_params
    stub_request(:get, events_uri + '?order=asc&page_size=1').to_return(events_list_response)

    events_list = event.list(conversation_id: conversation_id, order: 'asc', page_size: 1)

    assert_kind_of Vonage::Conversation::Event::ListResponse, events_list
    events_list.each { |event| assert_kind_of Vonage::Entity, event }
  end

  def test_list_method_without_conversation_id
    assert_raises(ArgumentError) { event.list }
  end

  def test_create_method
    stub_request(:post, events_uri).to_return(response)

    assert_kind_of Vonage::Response, event.create(conversation_id: conversation_id)
  end

  def test_create_method_with_optional_params
    stub_request(:post, events_uri).with(body: { type: 'message:delivered' }).to_return(response)

    assert_kind_of Vonage::Response, event.create(conversation_id: conversation_id, type: 'message:delivered')
  end

  def test_create_method_without_conversation_id
    assert_raises(ArgumentError) { event.create }
  end

  def test_find_method
    stub_request(:get, event_uri).to_return(response)

    assert_kind_of Vonage::Response, event.find(conversation_id: conversation_id, event_id: event_id)
  end

  def test_find_method_without_conversation_id
    assert_raises(ArgumentError) { event.find }
  end

  def test_find_method_without_event_id
    assert_raises(ArgumentError) { event.find(conversation_id: conversation_id) }
  end

  def test_delete_method
    stub_request(:delete, event_uri).to_return(response)

    assert_kind_of Vonage::Response, event.delete(conversation_id: conversation_id, event_id: event_id)
  end

  def test_delete_method_without_conversation_id
    assert_raises(ArgumentError) { event.delete }
  end

  def test_delete_method_without_event_id
    assert_raises(ArgumentError) { event.delete(conversation_id: conversation_id) }
  end
end
