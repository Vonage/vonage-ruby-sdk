require_relative './test'

class NexmoPricingTypesTest < Nexmo::Test
  def client
    Nexmo::Client.new
  end

  def pricing
    Nexmo::PricingTypes.new(client)
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
