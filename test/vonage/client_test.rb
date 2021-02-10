# typed: false
require_relative './test'

class Vonage::ClientTest < Vonage::Test
  def client
    Vonage::Client.new
  end

  def test_signature_method
    assert_kind_of Vonage::Signature, client.signature
  end

  def test_account_method
    assert_kind_of Vonage::Account, client.account
  end

  def test_alerts_method
    assert_kind_of Vonage::Alerts, client.alerts
  end

  def test_applications_method
    assert_kind_of Vonage::Applications, client.applications
  end

  def test_calls_method
    assert_kind_of Vonage::Voice, client.voice
  end

  def test_conversations_method
    assert_kind_of Vonage::Conversations, client.conversations
  end

  def test_conversions_method
    assert_kind_of Vonage::Conversions, client.conversions
  end

  def test_files_method
    assert_kind_of Vonage::Files, client.files
  end

  def test_messages_method
    assert_kind_of Vonage::Messages, client.messages
  end

  def test_number_insight_method
    assert_kind_of Vonage::NumberInsight, client.number_insight
  end

  def test_numbers_method
    assert_kind_of Vonage::Numbers, client.numbers
  end

  def test_pricing_method
    assert_kind_of Vonage::PricingTypes, client.pricing
  end

  def test_redact_method
    assert_kind_of Vonage::Redact, client.redact
  end

  def test_secrets_method
    assert_kind_of Vonage::Secrets, client.secrets
  end

  def test_sms_method
    assert_kind_of Vonage::SMS, client.sms
  end

  def test_tfa_method
    assert_kind_of Vonage::TFA, client.tfa
  end

  def test_verify_method
    assert_kind_of Vonage::Verify, client.verify
  end

  def test_raises_client_error_for_4xx_responses
    client = Vonage::Client.new(api_key: api_key, api_secret: api_secret)

    stub_request(:get, %r{\Ahttps://rest\.nexmo\.com/}).to_return(status: 400)

    assert_raises(Vonage::ClientError) { client.account.balance }
  end

  def test_raises_server_error_for_5xx_responses
    client = Vonage::Client.new(api_key: api_key, api_secret: api_secret)

    stub_request(:get, %r{\Ahttps://rest\.nexmo\.com/}).to_return(status: 500)

    assert_raises(Vonage::ServerError) { client.account.balance }
  end
end
