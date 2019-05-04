require_relative './test'

class NexmoCallsTest < Nexmo::Test
  def calls
    Nexmo::Calls.new(client)
  end

  def calls_uri
    'https://api.nexmo.com/v1/calls'
  end

  def call_uri
    'https://api.nexmo.com/v1/calls/' + call_uuid
  end

  def test_create_method
    params = {
      to: [{type: 'phone', number: '14843331234'}],
      from: {type: 'phone', number: '14843335555'},
      answer_url: ['https://example.com/answer']
    }

    request_stub = stub_request(:post, calls_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.create(params)
    assert_requested request_stub
  end

  def test_list_method
    params = {status: 'completed'}

    request_stub = stub_request(:get, calls_uri).with(request(query: params)).to_return(response)

    assert_equal response_object, calls.list(params)
    assert_requested request_stub
  end

  def test_get_method
    request_stub = stub_request(:get, call_uri).with(request).to_return(response)

    assert_equal response_object, calls.get(call_uuid)
    assert_requested request_stub
  end

  def test_update_method
    params = {action: 'hangup'}

    request_stub = stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.update(call_uuid, params)
    assert_requested request_stub
  end

  def test_hangup_method
    params = {action: 'hangup'}

    request_stub = stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.hangup(call_uuid)
    assert_requested request_stub
  end

  def test_mute_method
    params = {action: 'mute'}

    request_stub = stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.mute(call_uuid)
    assert_requested request_stub
  end

  def test_unmute_method
    params = {action: 'unmute'}

    request_stub = stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.unmute(call_uuid)
    assert_requested request_stub
  end

  def test_earmuff_method
    params = {action: 'earmuff'}

    request_stub = stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.earmuff(call_uuid)
    assert_requested request_stub
  end

  def test_unearmuff_method
    params = {action: 'unearmuff'}

    request_stub = stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.unearmuff(call_uuid)
    assert_requested request_stub
  end

  def test_transfer_method
    destination = {type: 'ncco', url: ['http://example.org/new-ncco.json']}

    params = {action: 'transfer', destination: destination}

    request_stub = stub_request(:put, call_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, calls.transfer(call_uuid, destination: destination)
    assert_requested request_stub
  end

  def test_stream_method
    assert_kind_of Nexmo::CallStream, calls.stream
  end

  def test_talk_method
    assert_kind_of Nexmo::CallTalk, calls.talk
  end

  def test_dtmf_method
    assert_kind_of Nexmo::CallDTMF, calls.dtmf
  end
end
