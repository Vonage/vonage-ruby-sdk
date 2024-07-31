# typed: false
require_relative './test'

class Vonage::NetworkAuthenticationTest < Vonage::Test
  def network_authentication
    Vonage::NetworkAuthentication.new(config)
  end

  def test_client_authentication_method
    assert_kind_of Vonage::NetworkAuthentication::ClientAuthentication, network_authentication.client_authentication
  end

  def test_server_authentication_method
    assert_kind_of Vonage::NetworkAuthentication::ServerAuthentication, network_authentication.server_authentication
  end
end
