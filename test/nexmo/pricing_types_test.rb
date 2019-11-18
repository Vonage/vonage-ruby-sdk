require_relative './test'

class Nexmo::PricingTypesTest < Nexmo::Test
  def pricing
    Nexmo::PricingTypes.new(config)
  end

  def test_sms_method
    assert_kind_of Nexmo::Pricing, pricing.sms
    assert_equal 'sms', pricing.sms.type
  end

  def test_voice_method
    assert_kind_of Nexmo::Pricing, pricing.voice
    assert_equal 'voice', pricing.voice.type
  end
end
