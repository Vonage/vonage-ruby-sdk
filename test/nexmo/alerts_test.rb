require_relative './test'

class NexmoAlertsTest < Nexmo::Test
  def alerts
    Nexmo::Alerts.new(client)
  end

  def msisdn
    '447700900000'
  end

  def test_list_method
    uri = 'https://rest.nexmo.com/sc/us/alert/opt-in/query/json'

    request = stub_request(:get, uri).with(query: api_key_and_secret).to_return(response)

    assert_equal response_object, alerts.list
    assert_requested request
  end

  def test_remove_method
    uri = 'https://rest.nexmo.com/sc/us/alert/opt-in/manage/json'

    params = {msisdn: msisdn}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, alerts.remove(params)
    assert_requested request
  end

  def test_resubscribe_method
    uri = 'https://rest.nexmo.com/sc/us/alert/opt-in/manage/json'

    params = {msisdn: msisdn}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, alerts.resubscribe(params)
    assert_requested request
  end

  def test_send_method
    uri = 'https://rest.nexmo.com/sc/us/alert/json'

    params = {to: msisdn, server: 'host3', link: 'https://example.com/host3/mon'}

    request = stub_request(:post, uri).with(body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, alerts.send(params)
    assert_requested request
  end
end
