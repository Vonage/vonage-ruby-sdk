require_relative './test'

class NexmoConversationLegsTest < Nexmo::Test
  def legs
    Nexmo::ConversationLegs.new(client)
  end

  def headers
    {'Authorization' => bearer_token}
  end

  def leg_id
    'xxxxxx'
  end

  def legs_uri
    'https://api.nexmo.com/beta/legs'
  end

  def leg_uri
    "https://api.nexmo.com/beta/legs/#{leg_id}"
  end

  def test_list_method
    request_stub = stub_request(:get, legs_uri).with(headers: headers).to_return(response)

    assert_equal response_object, legs.list
    assert_requested request_stub
  end

  def test_delete_method
    request_stub = stub_request(:delete, leg_uri).with(headers: headers).to_return(response)

    assert_equal response_object, legs.delete(leg_id)
    assert_requested request_stub
  end
end
