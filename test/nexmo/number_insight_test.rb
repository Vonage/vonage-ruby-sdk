require_relative './test'

class NexmoNumberInsightTest < Nexmo::Test
  def number_insight
    Nexmo::NumberInsight.new(client)
  end

  def params
    {number: msisdn}
  end

  def query
    params.merge(api_key_and_secret)
  end

  def test_basic_method
    uri = 'https://api.nexmo.com/ni/basic/json'

    request_stub = stub_request(:get, uri).with(query: query).to_return(response)

    assert_equal response_object, number_insight.basic(params)
    assert_requested request_stub
  end

  def test_standard_method
    uri = 'https://api.nexmo.com/ni/standard/json'

    request_stub = stub_request(:get, uri).with(query: query).to_return(response)

    assert_equal response_object, number_insight.standard(params)
    assert_requested request_stub
  end

  def test_advanced_method
    uri = 'https://api.nexmo.com/ni/advanced/json'

    request_stub = stub_request(:get, uri).with(query: query).to_return(response)

    assert_equal response_object, number_insight.advanced(params)
    assert_requested request_stub
  end

  def test_advanced_async_method
    uri = 'https://api.nexmo.com/ni/advanced/async/json'

    request_stub = stub_request(:get, uri).with(query: query).to_return(response)

    assert_equal response_object, number_insight.advanced_async(params)
    assert_requested request_stub
  end
end
