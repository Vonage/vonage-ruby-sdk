# typed: false
require_relative './test'

class Vonage::IdentityInsightsTest < Vonage::Test
  def identity_insights
    Vonage::IdentityInsights.new(config)
  end

  def geospecific_identity_insights
    config = Vonage::Config.new.merge(
      {
        application_id: application_id,
        private_key: private_key,
        vonage_host: 'api-us.vonage.com'
      }
    )

    Vonage::IdentityInsights.new(config)
  end

  def default_host
    'https://api-eu.vonage.com'
  end

  def geospecific_host
    'https://api-us.vonage.com'
  end

  def product_path
    '/identity-insights/v1/requests'
  end

  def identity_insights_uri
    default_host + product_path
  end

  def geospecific_identity_insights_uri
    geospecific_host + product_path
  end

  def phone_number
    '447900000000'
  end

  def test_requests_method
    params = {
      phone_number: phone_number,
      insights: {
        format: {}
      }
    }

    stub_request(:post, identity_insights_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, identity_insights.requests(phone_number: phone_number, insights: { format: {} })
  end

  def test_requests_method_with_optional_parameters
    params = {
      phone_number: phone_number,
      purpose: 'FraudPreventionAndDetection',
      insights: {
        sim_swap: {}
      }
    }

    stub_request(:post, identity_insights_uri).with(request(body: params)).to_return(response)

    response = identity_insights.requests(
      phone_number: phone_number,
      purpose: 'FraudPreventionAndDetection',
      insights: { sim_swap: {} }
    )

    assert_kind_of Vonage::Response, response
  end

  def test_requests_method_with_geospecific_host
    params = {
      phone_number: phone_number,
      insights: {
        format: {}
      }
    }

    stub_request(:post, geospecific_identity_insights_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, geospecific_identity_insights.requests(phone_number: phone_number, insights: { format: {} })
  end

  def test_requests_method_without_phone_number
    assert_raises(ArgumentError) { identity_insights.requests(insights: { format: {} }) }
  end

  def test_requests_method_with_empty_insights
    assert_raises(ArgumentError) { identity_insights.requests(phone_number: phone_number) }
  end

  def test_requests_method_with_invalid_insights_class
    assert_raises(ArgumentError) { identity_insights.requests(phone_number: phone_number, insights: ['format']) }
  end

  def test_requests_method_with_invalid_insights_type
    assert_raises(ArgumentError) { identity_insights.requests(phone_number: phone_number, insights: { foo: {} }) }
  end

  def test_insights_builder_method
    assert_kind_of Vonage::IdentityInsights::InsightsBuilder, identity_insights.insights_builder
  end

  def test_requests_method_with_insights_builder
    params = {
      phone_number: phone_number,
      insights: {
        format: {}
      }
    }
    
    builder = identity_insights.insights_builder
    builder.add_format

    stub_request(:post, identity_insights_uri).with(request(body: params)).to_return(response)

    assert_kind_of Vonage::Response, identity_insights.requests(phone_number: phone_number, insights: builder)
  end

  def test_requests_method_with_a_block
    params = {
      phone_number: phone_number,
      insights: {
        format: {}
      }
    }

    stub_request(:post, identity_insights_uri).with(request(body: params)).to_return(response)

    response = identity_insights.requests(phone_number: phone_number) do |builder|
      builder.add_format
    end

    assert_kind_of Vonage::Response, response
  end
end