require_relative './test'

class NexmoConversionsTest < Nexmo::Test
  def conversions
    Nexmo::Conversions.new(client)
  end

  def test_track_sms_method
    uri = 'https://api.nexmo.com/conversions/sms'

    params = {:'message-id' => 'xxx', :delivered => true}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, conversions.track_sms(params)
    assert_requested request
  end

  def test_track_voice_method
    uri = 'https://api.nexmo.com/conversions/voice'

    params = {:'message-id' => 'xxx', :delivered => true}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, conversions.track_voice(params)
    assert_requested request
  end
end
