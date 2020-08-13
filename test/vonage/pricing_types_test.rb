# typed: false
require_relative './test'

class Vonage::PricingTypesTest < Vonage::Test
  def pricing
    Vonage::PricingTypes.new(config)
  end

  def test_sms_method
    assert_kind_of Vonage::Pricing, pricing.sms
    assert_equal 'sms', pricing.sms.type
  end

  def test_voice_method
    assert_kind_of Vonage::Pricing, pricing.voice
    assert_equal 'voice', pricing.voice.type
  end
end
