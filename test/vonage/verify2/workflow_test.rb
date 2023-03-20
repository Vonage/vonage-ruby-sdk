# typed: false

class Vonage::Verify2::WorkflowTest < Vonage::Test
  def workflow
    Vonage::Verify2::Workflow.new
  end

  def test_workflow_with_valid_channel
    channel = workflow.sms(to: e164_compliant_number)

    assert_instance_of Vonage::Verify2::Channels::SMS, channel
    assert_equal 'sms', channel.channel
    assert_equal({channel: 'sms', to: e164_compliant_number}, channel.to_h)
  end

  def test_workflow_with_valid_channel_and_optional_parameters
    channel = workflow.whatsapp(to: e164_compliant_number, from: e164_compliant_number)

    assert_instance_of Vonage::Verify2::Channels::WhatsApp, channel
    assert_equal 'whatsapp', channel.channel
    assert_equal({channel: 'whatsapp', to: e164_compliant_number, from: e164_compliant_number}, channel.to_h)
  end

  def test_workflow_with_invalid_channel
    assert_raises { workflow.magic }
  end

  Vonage::Verify2::Workflow::CHANNELS.keys.each do |method_name|
    define_method "test_#{method_name}_workflow_method" do
      assert_respond_to workflow, method_name
    end
  end

  def test_list_getter_method
    flow = workflow

    assert_equal flow.instance_variable_get(:@list).object_id, flow.list.object_id
  end

  def test_shovel_method
    flow = workflow
    channel1 = flow.sms(to: e164_compliant_number)
    channel2 = flow.whatsapp(to: e164_compliant_number)
    flow << channel1
    flow << channel2

    assert_equal channel1.object_id, flow.list.first.object_id
    assert_equal channel2.object_id, flow.list.last.object_id
  end

  def test_hashified_list_method
    flow = workflow
    flow << flow.sms(to: e164_compliant_number)
    flow << flow.whatsapp(to: e164_compliant_number)

    hashified_list = flow.hashified_list
    assert hashified_list.all?(Hash)
    assert_equal 'sms', hashified_list.first[:channel]
    assert_equal 'whatsapp', hashified_list.last[:channel]
  end
end
