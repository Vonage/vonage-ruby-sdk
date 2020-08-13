# typed: false
require_relative './test'

class Vonage::RedactTest < Vonage::Test
  def redact
    Vonage::Redact.new(config)
  end

  def authorization
    basic_authorization
  end

  def test_transaction_method
    uri = 'https://api.nexmo.com/v1/redact/transaction'

    params = {id: '00A0B0C0', product: 'sms'}

    stub_request(:post, uri).with(request(body: params)).to_return(status: 204)

    assert_kind_of Vonage::Response, redact.transaction(params)
  end
end
