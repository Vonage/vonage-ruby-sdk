# typed: false
require_relative './test'

class Vonage::ConversionsTest < Vonage::Test
  def conversions
    Vonage::Conversions.new(config)
  end

  def message_id
    'message-id'
  end

  def test_track_sms_method
    uri = 'https://api.nexmo.com/conversions/sms'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, conversions.track_sms(message_id: message_id, delivered: true)
  end

  def test_track_voice_method
    uri = 'https://api.nexmo.com/conversions/voice'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_kind_of Vonage::Response, conversions.track_voice(message_id: message_id, delivered: true)
  end
end
