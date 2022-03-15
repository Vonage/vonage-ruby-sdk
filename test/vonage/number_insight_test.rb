# typed: false
require_relative './test'

class Vonage::NumberInsightTest < Vonage::Test
  def number_insight
    Vonage::NumberInsight.new(config)
  end

  def params
    {number: msisdn}
  end

  def query
    params.merge(api_key_and_secret)
  end

  def response
    {
      headers: response_headers,
      body: '{"status":0}'
    }
  end

  def error_response
    {
      headers: response_headers,
      body: '{"status":1}'
    }
  end

  def test_basic_method
    uri = 'https://api.nexmo.com/ni/basic/json'

    stub_request(:get, uri).with(query: query).to_return(response, error_response)

    assert_kind_of Vonage::Response, number_insight.basic(params)

    error = assert_raises Vonage::ServiceError do
      number_insight.basic(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_standard_method
    uri = 'https://api.nexmo.com/ni/standard/json'

    stub_request(:get, uri).with(query: query).to_return(response, error_response)

    assert_kind_of Vonage::Response, number_insight.standard(params)

    error = assert_raises Vonage::ServiceError do
      number_insight.standard(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_advanced_method
    uri = 'https://api.nexmo.com/ni/advanced/json'

    stub_request(:get, uri).with(query: query).to_return(response, error_response)

    assert_kind_of Vonage::Response, number_insight.advanced(params)

    error = assert_raises Vonage::ServiceError do
      number_insight.advanced(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end

  def test_advanced_async_method
    uri = 'https://api.nexmo.com/ni/advanced/async/json'

    stub_request(:get, uri).with(query: query).to_return(response, error_response)

    assert_kind_of Vonage::Response, number_insight.advanced_async(params)

    error = assert_raises Vonage::ServiceError do
      number_insight.advanced_async(params)
    end

    assert_kind_of Vonage::Error, error
    assert_kind_of Vonage::Response, error.response
  end
end
