# typed: false
require_relative './test'

class Vonage::ConversionsTest < Vonage::Test
  def conversions
    Vonage::Conversions.new(config)
  end

  def conversions_with_sig_auth
    config = Vonage::Config.new.merge(
      {
        api_key: api_key,
        signature_secret: signature_secret,
        authentication_preference: :signature
      }
    )
    Vonage::Conversions.new(config)
  end

  def authorization
    basic_authorization
  end

  def message_id
    'message-id'
  end

  def test_track_sms_method
    uri = 'https://api.nexmo.com/conversions/sms'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    stub_request(:post, uri).with(request(headers: headers, body: params)).to_return(response)

    assert_kind_of Vonage::Response, conversions.track_sms(message_id: message_id, delivered: true)
  end

  def test_track_sms_method_with_signature_authenitication
    uri = 'https://api.nexmo.com/conversions/sms'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    stub_request(:post, uri).with(headers: headers, body: hash_including(params)) do |request|
      request.body.include?('api_key=') && request.body.include?('timestamp=') && request.body.include?('sig=')
    end.to_return(response)

    assert_kind_of Vonage::Response, conversions_with_sig_auth.track_sms(message_id: message_id, delivered: true)
  end

  def test_track_voice_method
    uri = 'https://api.nexmo.com/conversions/voice'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    stub_request(:post, uri).with(request(headers: headers, body: params)).to_return(response)

    assert_kind_of Vonage::Response, conversions.track_voice(message_id: message_id, delivered: true)
  end

  def test_track_voice_method_with_signature_authenitication
    uri = 'https://api.nexmo.com/conversions/voice'

    params = {'message-id' => message_id, 'delivered' => 'true'}

    stub_request(:post, uri).with(headers: headers, body: hash_including(params)) do |request|
      request.body.include?('api_key=') && request.body.include?('timestamp=') && request.body.include?('sig=')
    end.to_return(response)

    assert_kind_of Vonage::Response, conversions_with_sig_auth.track_voice(message_id: message_id, delivered: true)
  end
end
