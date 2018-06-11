require_relative './test'

class NexmoRedactTest < Nexmo::Test
  def redact
    Nexmo::Redact.new(client)
  end

  def test_transaction_method
    uri = 'https://api.nexmo.com/v1/redact/transaction'

    headers = {'Content-Type' => 'application/json'}

    params = {id: '00A0B0C0', product: 'sms'}

    request = stub_request(:post, uri).with(query: api_key_and_secret, headers: headers, body: params).to_return(status: 204)

    assert_equal :no_content, redact.transaction(params)
    assert_requested request
  end
end
