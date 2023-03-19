# typed: false

class Vonage::Verify2::Workflows::EmailTest < Vonage::Test
  def email_workflow
    Vonage::Verify2::Workflows::Email.new(to: valid_email)
  end

  def valid_email
    'alice@example.com'
  end

  def channel_getter_method
    assert_equal 'whatsapp', email_workflow.channel
  end

  def test_to_getter_method
    assert_equal valid_email, email_workflow.to
  end

  def test_to_setter_method
    workflow = email_workflow
    new_email = 'bob@example.com'
    workflow.to = new_email

    assert_equal new_email, workflow.instance_variable_get(:@to)
  end

  def test_from_getter_method
    assert_nil email_workflow.from
  end

  def test_from_setter_method
    workflow = email_workflow
    workflow.from = valid_email

    assert_equal valid_email, workflow.instance_variable_get(:@from)
  end

  def test_to_h_method
    workflow_hash = Vonage::Verify2::Workflows::Email.new(
      to: valid_email,
      from: valid_email
    ).to_h

    assert_kind_of Hash, workflow_hash
    assert_equal valid_email, workflow_hash[:to]
    assert_equal valid_email, workflow_hash[:from]
  end
end
