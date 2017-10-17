require_relative './test'

class NexmoClientTest < Nexmo::Test
  def test_api_key_method
    assert_equal client.api_key, api_key
  end

  def test_api_key_method_raises_authentication_error
    client = Nexmo::Client.new

    exception = assert_raises(Nexmo::AuthenticationError) { client.api_key }

    assert_includes exception.message, 'No API key provided.'
  end

  def test_api_secret_method
    assert_equal client.api_secret, api_secret
  end

  def test_api_secret_method_raises_authentication_error
    client = Nexmo::Client.new

    exception = assert_raises(Nexmo::AuthenticationError) { client.api_secret }

    assert_includes exception.message, 'No API secret provided.'
  end

  def test_signature_secret_method
    assert_equal client.signature_secret, signature_secret
  end

  def test_signature_secret_method_raises_authentication_error
    client = Nexmo::Client.new

    exception = assert_raises(Nexmo::AuthenticationError) { client.signature_secret }

    assert_includes exception.message, 'No signature_secret provided.'
  end

  def test_application_id_method
    assert_equal client.application_id, application_id
  end

  def test_application_id_method_raises_authentication_error
    client = Nexmo::Client.new

    exception = assert_raises(Nexmo::AuthenticationError) { client.application_id }

    assert_includes exception.message, 'No application_id provided.'
  end

  def test_private_key_method
    assert_equal client.private_key, private_key
  end

  def test_private_key_method_raises_authentication_error
    client = Nexmo::Client.new

    exception = assert_raises(Nexmo::AuthenticationError) { client.private_key }

    assert_includes exception.message, 'No private_key provided.'
  end

  def test_signature_method
    assert_kind_of Nexmo::Signature, client.signature
  end

  def test_account_method
    assert_kind_of Nexmo::Account, client.account
  end

  def test_alerts_method
    assert_kind_of Nexmo::Alerts, client.alerts
  end

  def test_applications_method
    assert_kind_of Nexmo::Applications, client.applications
  end

  def test_calls_method
    assert_kind_of Nexmo::Calls, client.calls
  end

  def test_conversions_method
    assert_kind_of Nexmo::Conversions, client.conversions
  end

  def test_files_method
    assert_kind_of Nexmo::Files, client.files
  end

  def test_messages_method
    assert_kind_of Nexmo::Messages, client.messages
  end

  def test_number_insight_method
    assert_kind_of Nexmo::NumberInsight, client.number_insight
  end

  def test_numbers_method
    assert_kind_of Nexmo::Numbers, client.numbers
  end

  def test_pricing_method
    assert_kind_of Nexmo::PricingTypes, client.pricing
  end

  def test_sms_method
    assert_kind_of Nexmo::SMS, client.sms
  end

  def test_verify_method
    assert_kind_of Nexmo::Verify, client.verify
  end
end
