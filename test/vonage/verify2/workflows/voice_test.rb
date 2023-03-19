# typed: false

class Vonage::Verify2::Workflows::VoiceTest < Vonage::Test
  def voice_workflow
    Vonage::Verify2::Workflows::Voice.new(to: e164_compliant_number)
  end

  def channel_getter_method
    assert_equal 'voice', voice_workflow.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, voice_workflow.to
  end

  def test_to_setter_method
    workflow = voice_workflow
    new_number = '447000000001'
    workflow.to = new_number

    assert_equal new_number, workflow.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      voice_workflow.to = invalid_number
    end
  end

  def test_to_h_method
    workflow_hash = Vonage::Verify2::Workflows::Voice.new(to: e164_compliant_number).to_h

    assert_kind_of Hash, workflow_hash
    assert_equal e164_compliant_number, workflow_hash[:to]
  end
end
