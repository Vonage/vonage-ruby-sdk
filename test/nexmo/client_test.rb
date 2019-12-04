require_relative './test'

class NexmoClientTest < Nexmo::Test
  def client
    Nexmo::Client.new
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

  def test_conversations_method
    assert_kind_of Nexmo::Conversations, client.conversations
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

  def test_redact_method
    assert_kind_of Nexmo::Redact, client.redact
  end

  def test_secrets_method
    assert_kind_of Nexmo::Secrets, client.secrets
  end

  def test_sms_method
    assert_kind_of Nexmo::SMS, client.sms
  end

  def test_tfa_method
    assert_kind_of Nexmo::TFA, client.tfa
  end

  def test_verify_method
    assert_kind_of Nexmo::Verify, client.verify
  end

  def test_raises_client_error_for_4xx_responses
    client = Nexmo::Client.new(api_key: api_key, api_secret: api_secret)

    stub_request(:get, %r{\Ahttps://rest\.nexmo\.com/}).to_return(status: 400)

    assert_raises(Nexmo::ClientError) { client.account.balance }
  end

  def test_raises_server_error_for_5xx_responses
    client = Nexmo::Client.new(api_key: api_key, api_secret: api_secret)

    stub_request(:get, %r{\Ahttps://rest\.nexmo\.com/}).to_return(status: 500)

    assert_raises(Nexmo::ServerError) { client.account.balance }
  end
end
