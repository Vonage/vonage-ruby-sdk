# typed: false
require_relative './test'

class Vonage::ConfigTest < Vonage::Test
  def test_api_key_method
    assert_equal config.api_key, api_key
  end

  def test_api_key_method_raises_authentication_error
    config = Vonage::Config.new

    exception = assert_raises(Vonage::AuthenticationError) { config.api_key }

    assert_includes exception.message, 'No API key provided.'
  end

  def test_api_secret_method
    assert_equal config.api_secret, api_secret
  end

  def test_api_secret_method_raises_authentication_error
    config = Vonage::Config.new

    exception = assert_raises(Vonage::AuthenticationError) { config.api_secret }

    assert_includes exception.message, 'No API secret provided.'
  end

  def test_application_id_method
    assert_equal config.application_id, application_id
  end

  def test_application_id_method_raises_authentication_error
    config = Vonage::Config.new

    exception = assert_raises(Vonage::AuthenticationError) { config.application_id }

    assert_includes exception.message, 'No application_id provided.'
  end

  def test_private_key_method
    assert_equal config.private_key, private_key
  end

  def test_private_key_method_raises_authentication_error
    config = Vonage::Config.new

    exception = assert_raises(Vonage::AuthenticationError) { config.private_key }

    assert_includes exception.message, 'No private_key provided.'
  end

  def test_signature_secret_method
    assert_equal config.signature_secret, signature_secret
  end

  def test_signature_secret_method_raises_authentication_error
    config = Vonage::Config.new

    exception = assert_raises(Vonage::AuthenticationError) { config.signature_secret }

    assert_includes exception.message, 'No signature_secret provided.'
  end
end
