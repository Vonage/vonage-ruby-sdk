require_relative './test'

class NexmoConversionsTest < Nexmo::Test
  def conversions
    Nexmo::Conversions.new(client)
  end

  def message_id
    'message-id'
  end

  def test_track_sms_method
    uri = 'https://api.nexmo.com/conversions/sms'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    request_stub = stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, conversions.track_sms(message_id: message_id, delivered: true)
    assert_requested request_stub
  end

  def test_track_voice_method
    uri = 'https://api.nexmo.com/conversions/voice'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    request_stub = stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, conversions.track_voice(message_id: message_id, delivered: true)
    assert_requested request_stub
  end
end
