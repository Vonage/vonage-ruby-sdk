# typed: false

class Vonage::Voice::NccoTest < Vonage::Test
  def ncco
    Vonage::Voice::Ncco
  end

  def test_ncco_with_valid_action
    action = ncco.connect(endpoint: { type: 'phone', number: '12129999999' })

    assert_equal action, [{:action=>"connect", :endpoint=>[{:type=>"phone", :number=>"12129999999"}]}]
  end

  def test_ncco_with_valid_action_and_optional_parameters
    action = ncco.connect(endpoint: { type: 'phone', number: '12129999999' }, from: '12129992222')

    assert_equal action, [{:action=>"connect", :endpoint=>[{:type=>"phone", :number=>"12129999999"}], :from=>'12129992222'}]
  end

  def test_ncco_with_invalid_action
    exception = assert_raises { ncco.gotowarp }
    
    assert_match "NCCO action must be one of the valid options. Please refer to https://developer.nexmo.com/voice/voice-api/ncco-reference#ncco-actions for a complete list.", exception.message
  end
end