require_relative './test'

class NexmoAlertsTest < Nexmo::Test
  def alerts
    Nexmo::Alerts.new(config)
  end

  def test_list_method
    uri = 'https://rest.nexmo.com/sc/us/alert/opt-in/query/json'

    stub_request(:get, uri).with(query: api_key_and_secret).to_return(response)

    assert_equal response_object, alerts.list
  end

  def test_remove_method
    uri = 'https://rest.nexmo.com/sc/us/alert/opt-in/manage/json'

    params = {msisdn: msisdn}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, alerts.remove(params)
  end

  def test_resubscribe_method
    uri = 'https://rest.nexmo.com/sc/us/alert/opt-in/manage/json'

    params = {msisdn: msisdn}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, alerts.resubscribe(params)
  end

  def test_send_method
    uri = 'https://rest.nexmo.com/sc/us/alert/json'

    params = {to: msisdn, server: 'host3', link: 'https://example.com/host3/mon'}

    stub_request(:post, uri).with(headers: headers, body: params.merge(api_key_and_secret)).to_return(response)

    assert_equal response_object, alerts.send(params)
  end
end
