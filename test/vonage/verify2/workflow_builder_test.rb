# typed: false

class Vonage::Verify2::WorkflowTest < Vonage::Test
  def workflow_bulder
    Vonage::Verify2::WorkflowBuilder.new
  end

  Vonage::Verify2::Workflow::CHANNELS.keys.each do |channel|
    define_method "test_add_#{channel}_channel_method" do
      assert_respond_to workflow_bulder, "add_#{channel}"
    end
  end

  def test_build_method
    workflow = Vonage::Verify2::WorkflowBuilder.build do |builder|
      builder.add_sms(to: e164_compliant_number)
    end

    assert_instance_of Vonage::Verify2::Workflow, workflow
    assert_instance_of Vonage::Verify2::Channels::SMS, workflow.list.first
    assert_equal({channel: 'sms', to: e164_compliant_number}, workflow.list.first.to_h)
  end

  def test_build_method_adding_multiple_channels
    workflow = Vonage::Verify2::WorkflowBuilder.build do |builder|
      builder.add_sms(to: e164_compliant_number)
      builder.add_whatsapp(to: e164_compliant_number)
    end

    assert_instance_of Vonage::Verify2::Workflow, workflow
    assert_instance_of Vonage::Verify2::Channels::SMS, workflow.list.first
    assert_instance_of Vonage::Verify2::Channels::WhatsApp, workflow.list.last
    assert_equal({channel: 'whatsapp', to: e164_compliant_number}, workflow.list.last.to_h)
  end
end
