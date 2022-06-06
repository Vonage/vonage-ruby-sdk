# typed: false
require_relative './test'

class Vonage::MessagingTest < Vonage::Test
  def messaging
    Vonage::Messaging.new(config)
  end

  def messaging_uri
    'https://api.nexmo.com/v1/messages'
  end

  def test_send_method
    params = {
      to: "447700900000",
      from: "447700900001",
      channel: "sms",
      message_type: "text",
      text: "Hello world!"
    }

    stub_request(:post, messaging_uri).with(request(body: params)).to_return(response)

    message = Vonage::Messaging::Message.sms(message: "Hello world!")
    
    assert_kind_of Vonage::Response, messaging.send(to: "447700900000", from: "447700900001", **message)
  end
end
