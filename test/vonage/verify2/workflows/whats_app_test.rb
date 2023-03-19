# typed: false

class Vonage::Verify2::Workflows::WhatsAppTest < Vonage::Test
  def whatsapp_workflow
    Vonage::Verify2::Workflows::WhatsApp.new(to: e164_compliant_number)
  end

  def channel_getter_method
    assert_equal 'whatsapp', whatsapp_workflow.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, whatsapp_workflow.to
  end

  def test_to_setter_method
    workflow = whatsapp_workflow
    new_number = '447000000001'
    workflow.to = new_number

    assert_equal new_number, workflow.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      whatsapp_workflow.to = invalid_number
    end
  end

  def test_from_getter_method
    assert_nil whatsapp_workflow.from
  end

  def test_from_setter_method
    workflow = whatsapp_workflow
    workflow.from = e164_compliant_number

    assert_equal e164_compliant_number, workflow.instance_variable_get(:@from)
  end

  def test_from_setter_method_with_invalid_arg
    assert_raises ArgumentError do
      whatsapp_workflow.from = invalid_number
    end
  end

  def test_to_h_method
    workflow_hash = Vonage::Verify2::Workflows::WhatsApp.new(
      to: e164_compliant_number,
      from: e164_compliant_number
    ).to_h

    assert_kind_of Hash, workflow_hash
    assert_equal e164_compliant_number, workflow_hash[:to]
    assert_equal e164_compliant_number, workflow_hash[:from]
  end
end
