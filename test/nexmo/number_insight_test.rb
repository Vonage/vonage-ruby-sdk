require_relative './test'

class NexmoNumberInsightTest < Nexmo::Test
  def number_insight
    Nexmo::NumberInsight.new(config)
  end

  def params
    {number: msisdn}
  end

  def query
    params.merge(api_key_and_secret)
  end

  def test_basic_method
    uri = 'https://api.nexmo.com/ni/basic/json'

    stub_request(:get, uri).with(query: query).to_return(response)

    assert_kind_of Nexmo::NumberInsight::Response, number_insight.basic(params)
  end

  def test_standard_method
    uri = 'https://api.nexmo.com/ni/standard/json'

    stub_request(:get, uri).with(query: query).to_return(response)

    assert_kind_of Nexmo::NumberInsight::Response, number_insight.standard(params)
  end

  def test_advanced_method
    uri = 'https://api.nexmo.com/ni/advanced/json'

    stub_request(:get, uri).with(query: query).to_return(response)

    assert_kind_of Nexmo::NumberInsight::Response, number_insight.advanced(params)
  end

  def test_advanced_async_method
    uri = 'https://api.nexmo.com/ni/advanced/async/json'

    stub_request(:get, uri).with(query: query).to_return(response)

    assert_kind_of Nexmo::NumberInsight::Response, number_insight.advanced_async(params)
  end
end
