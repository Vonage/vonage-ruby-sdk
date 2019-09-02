require_relative './test'

class NexmoConversationLegsTest < Nexmo::Test
  def legs
    Nexmo::ConversationLegs.new(config)
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
    stub_request(:get, legs_uri).with(request).to_return(response)

    assert_equal response_object, legs.list
  end

  def test_delete_method
    stub_request(:delete, leg_uri).with(request).to_return(response)

    assert_equal response_object, legs.delete(leg_id)
  end
end
