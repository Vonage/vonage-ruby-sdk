# typed: false

class Vonage::IdentityInsights::InsightsBuilderTest < Vonage::Test
  def identity_insights
    Vonage::IdentityInsights.new(config)
  end

  def test_add_format_method
    expected = {format: {}}
    builder = identity_insights.insights_builder
    builder.add_format

    assert_equal expected, builder.to_h
  end

  def test_add_sim_swap_method
    expected = {sim_swap: {}}
    builder = identity_insights.insights_builder
    builder.add_sim_swap

    assert_equal expected, builder.to_h
  end

  def test_add_current_carrier_method
    expected = {current_carrier: {}}
    builder = identity_insights.insights_builder
    builder.add_current_carrier

    assert_equal expected, builder.to_h
  end

  def test_add_previous_carrier_method
    expected = {previous_carrier: {}}
    builder = identity_insights.insights_builder
    builder.add_previous_carrier

    assert_equal expected, builder.to_h
  end

  def test_to_h_method
    builder = identity_insights.insights_builder

    assert_instance_of(Hash, builder.to_h)
  end
end