# typed: false

class Vonage::Verify2::Workflows::SMSTest < Vonage::Test
  def sms_workflow
    Vonage::Verify2::Workflows::SMS.new(to: e164_compliant_number)
  end

  def valid_android_app_hash
    'FA+9qCX9VSu'
  end

  def channel_getter_method
    assert_equal 'sms', sms_workflow.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, sms_workflow.to
  end

  def test_to_setter_method
    workflow = sms_workflow
    new_number = '447000000001'
    workflow.to = new_number

    assert_equal new_number, workflow.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      sms_workflow.to = invalid_number
    end
  end

  def test_app_hash_getter_method
    assert_nil sms_workflow.app_hash
  end

  def test_app_hash_setter_method
    workflow = sms_workflow
    workflow.app_hash = valid_android_app_hash

    assert_equal valid_android_app_hash, workflow.instance_variable_get(:@app_hash)
  end

  def test_app_hash_setter_method_with_invalid_arg
    assert_raises ArgumentError do
      sms_workflow.app_hash = valid_android_app_hash[0..8]
    end
  end

  def test_to_h_method
    workflow_hash = Vonage::Verify2::Workflows::SMS.new(
      to: e164_compliant_number,
      app_hash: valid_android_app_hash
    ).to_h

    assert_kind_of Hash, workflow_hash
    assert_equal e164_compliant_number, workflow_hash[:to]
    assert_equal valid_android_app_hash, workflow_hash[:app_hash]
  end
end
