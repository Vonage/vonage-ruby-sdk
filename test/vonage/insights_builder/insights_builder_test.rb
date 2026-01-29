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

  def test_add_sim_swap_method_with_period
    expected = {sim_swap: { period: 300 }}
    builder = identity_insights.insights_builder
    builder.add_sim_swap(period: 300)

    assert_equal expected, builder.to_h
  end

  def test_add_sim_swap_method_with_invalid_period_type
    builder = identity_insights.insights_builder
    assert_raises(ArgumentError) { builder.add_sim_swap(period: 'three_hundred') }
  end

  def test_add_sim_swap_method_with_invalid_period_range_too_low
    builder = identity_insights.insights_builder
    assert_raises(ArgumentError) { builder.add_sim_swap(period: 0) }
  end

  def test_add_sim_swap_method_with_invalid_period_range_too_high
    builder = identity_insights.insights_builder
    assert_raises(ArgumentError) { builder.add_sim_swap(period: 2401) }
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

  def test_adding_multiple_insights
    expected = {
      format: {},
      sim_swap: {},
      current_carrier: {},
      previous_carrier: {}
    }
    builder = identity_insights.insights_builder
    builder.add_format
    builder.add_sim_swap
    builder.add_current_carrier
    builder.add_previous_carrier

    assert_equal expected, builder.to_h
  end

  def test_adding_multiple_insights_with_method_chaining
    expected = {
      format: {},
      sim_swap: {},
      current_carrier: {},
      previous_carrier: {}
    }
    builder = identity_insights.insights_builder
    builder.add_format
      .add_sim_swap
      .add_current_carrier
      .add_previous_carrier
    
    assert_equal expected, builder.to_h
  end

  def test_to_h_method
    builder = identity_insights.insights_builder

    assert_instance_of(Hash, builder.to_h)
  end
end