require_relative '../test'

class Nexmo::Calls::DTMFTest < Nexmo::Test
  def dtmf
    Nexmo::Calls::DTMF.new(config)
  end

  def uri
    'https://api.nexmo.com/v1/calls/' + call_uuid + '/dtmf'
  end

  def test_send_method
    params = {digits: '1234'}

    stub_request(:put, uri).with(request(body: params)).to_return(response)

    assert_kind_of Nexmo::Response, dtmf.send(call_uuid, params)
  end
end
