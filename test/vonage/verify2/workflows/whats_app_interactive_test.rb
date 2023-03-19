# typed: false

class Vonage::Verify2::Workflows::WhatsAppInteractiveTest < Vonage::Test
  def whatsapp_interactive_workflow
    Vonage::Verify2::Workflows::WhatsAppInteractive.new(to: e164_compliant_number)
  end

  def channel_getter_method
    assert_equal 'whatsapp_interactive', whatsapp_interactive_workflow.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, whatsapp_interactive_workflow.to
  end

  def test_to_setter_method
    workflow = whatsapp_interactive_workflow
    new_number = '447000000001'
    workflow.to = new_number

    assert_equal new_number, workflow.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      whatsapp_interactive_workflow.to = invalid_number
    end
  end

  def test_to_h_method
    workflow_hash = Vonage::Verify2::Workflows::WhatsAppInteractive.new(to: e164_compliant_number).to_h

    assert_kind_of Hash, workflow_hash
    assert_equal e164_compliant_number, workflow_hash[:to]
  end
end
