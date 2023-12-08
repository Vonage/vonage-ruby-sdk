# typed: false
require_relative './test'

class Vonage::NumberInsight2Test < Vonage::Test
  def number_insight_2
    Vonage::NumberInsight2.new(config)
  end

  def uri
    'https://api.nexmo.com/v2/ni'
  end

  def number
    '447700900000'
  end

  def test_fraud_check_method
    params = {type: 'phone', phone: number, insights: ['fraud_score', 'sim_swap']}
    stub_request(:post, uri).with(body: params).to_return(response)

    assert_kind_of Vonage::Response, number_insight_2.fraud_check(**params)
  end

  def test_fraud_check_method_without_type
    params = {phone: number, insights: ['fraud_score', 'sim_swap']}

    assert_raises ArgumentError do
      number_insight_2.fraud_check(**params)
    end
  end

  def test_fraud_check_method_without_phone
    params = {type: 'phone', insights: ['fraud_score', 'sim_swap']}

    assert_raises ArgumentError do
      number_insight_2.fraud_check(**params)
    end
  end

  def test_fraud_check_method_without_insights
    params = {type: 'phone', phone: number}

    assert_raises ArgumentError do
      number_insight_2.fraud_check(**params)
    end
  end

  def test_fraud_check_method_with_insights_not_an_array
    params = {type: 'phone', phone: number, insights: 'fraud_score'}

    assert_raises TypeError do
      number_insight_2.fraud_check(**params)
    end
  end

  def test_fraud_check_method_with_insights_an_empty_array
    params = {type: 'phone', phone: number, insights: []}

    assert_raises ArgumentError do
      number_insight_2.fraud_check(**params)
    end
  end
end
