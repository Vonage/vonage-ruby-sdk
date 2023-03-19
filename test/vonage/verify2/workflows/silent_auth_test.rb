# typed: false

class Vonage::Verify2::Workflows::SilentAuthTest < Vonage::Test
  def silent_auth_workflow
    Vonage::Verify2::Workflows::SilentAuth.new(to: e164_compliant_number)
  end

  def channel_getter_method
    assert_equal 'silent_auth', silent_auth_workflow.channel
  end

  def test_to_getter_method
    assert_equal e164_compliant_number, silent_auth_workflow.to
  end

  def test_to_setter_method
    workflow = silent_auth_workflow
    new_number = '447000000001'
    workflow.to = new_number

    assert_equal new_number, workflow.instance_variable_get(:@to)
  end

  def test_to_setter_method_with_invalid_number
    assert_raises ArgumentError do
      silent_auth_workflow.to = invalid_number
    end
  end

  def test_to_h_method
    workflow_hash = Vonage::Verify2::Workflows::SilentAuth.new(to: e164_compliant_number).to_h

    assert_kind_of Hash, workflow_hash
    assert_equal e164_compliant_number, workflow_hash[:to]
  end
end
