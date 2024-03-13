# typed: false
require_relative '../test'

class Vonage::Conversation::MemberTest < Vonage::Test
  def member
    Vonage::Conversation::Member.new(config)
  end

  def members_uri
    "https://api.nexmo.com/v1/conversations/#{conversation_id}/members"
  end

  def member_uri
    "https://api.nexmo.com/v1/conversations/#{conversation_id}/members/#{member_id}"
  end

  def test_list_method
    stub_request(:get, members_uri).to_return(members_list_response)

    members_list = member.list(conversation_id: conversation_id)

    assert_kind_of Vonage::Conversation::Member::ListResponse, members_list
    members_list.each { |member| assert_kind_of Vonage::Entity, member }
  end

  def test_list_method_with_optional_params
    stub_request(:get, members_uri + '?order=asc&page_size=1').to_return(members_list_response)

    members_list = member.list(conversation_id: conversation_id, order: 'asc', page_size: 1)

    assert_kind_of Vonage::Conversation::Member::ListResponse, members_list
    members_list.each { |member| assert_kind_of Vonage::Entity, member }
  end

  def test_list_method_without_conversation_id
    assert_raises(ArgumentError) { member.list }
  end

  def test_create_method
    stub_request(:post, members_uri).to_return(response)

    assert_kind_of Vonage::Response, member.create(conversation_id: conversation_id)
  end

  def test_create_method_with_optional_params
    stub_request(:post, members_uri).with(body: { state: 'joined' }).to_return(response)

    assert_kind_of Vonage::Response, member.create(conversation_id: conversation_id, state: 'joined')
  end

  def test_create_method_without_conversation_id
    assert_raises(ArgumentError) { member.create }
  end

  def test_find_method
    stub_request(:get, member_uri).to_return(response)

    assert_kind_of Vonage::Response, member.find(conversation_id: conversation_id, member_id: member_id)
  end

  def test_find_method_without_conversation_id
    assert_raises(ArgumentError) { member.find(member_id: member_id) }
  end

  def test_find_method_without_member_id
    assert_raises(ArgumentError) { member.find(conversation_id: conversation_id) }
  end

  def test_update_method
    stub_request(:patch, member_uri).with(body: { state: 'left' }).to_return(response)

    assert_kind_of Vonage::Response, member.update(conversation_id: conversation_id, member_id: member_id, state: 'left')
  end

  def test_update_method_without_conversation_id
    assert_raises(ArgumentError) { member.update(member_id: member_id) }
  end

  def test_update_method_without_member_id
    assert_raises(ArgumentError) { member.update(conversation_id: conversation_id) }
  end
end
