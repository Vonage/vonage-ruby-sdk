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

  def test_list_method
    stub_request(:get, conversations_uri).to_return(conversation_list_response)
    conversation_list = conversation.list

    assert_kind_of Vonage::Conversation::ListResponse, conversation_list
    conversation_list.each { |conversation| assert_kind_of Vonage::Entity, conversation }
  end

  def test_list_method_with_optional_params
    stub_request(:get, conversations_uri + "?page_size=1&order=asc").to_return(conversation_list_response)
    conversation_list = conversation.list(order: 'asc', page_size: 1)

    assert_kind_of Vonage::Conversation::ListResponse, conversation_list
    conversation_list.each { |conversation| assert_kind_of Vonage::Entity, conversation }
  end

  def test_create_method
    stub_request(:post, conversations_uri).to_return(response)

    assert_kind_of Vonage::Response, conversation.create
  end

  def test_create_method_with_optional_params
    stub_request(:post, conversations_uri).with(body: { display_name: 'Test Conversation' }).to_return(response)

    assert_kind_of Vonage::Response, conversation.create(display_name: 'Test Conversation')
  end

  def test_find_method
    stub_request(:get, conversation_uri).to_return(response)

    assert_kind_of Vonage::Response, conversation.find(conversation_id: conversation_id)
  end

  def test_find_method_without_conversation_id
    assert_raises(ArgumentError) { conversation.find }
  end

  def test_update_method
    stub_request(:put, conversation_uri).with(body: { display_name: 'Updated Conversation' }).to_return(response)

    assert_kind_of Vonage::Response, conversation.update(conversation_id: conversation_id, display_name: 'Updated Conversation')
  end

  def test_update_method_without_conversation_id
    assert_raises(ArgumentError) { conversation.update }  
  end

  def test_delete_method
    stub_request(:delete, conversation_uri).to_return(response)
    
    assert_kind_of Vonage::Response, conversation.delete(conversation_id: conversation_id)
  end

  def test_delete_method_without_conversation_id
    assert_raises(ArgumentError) { conversation.delete }
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
