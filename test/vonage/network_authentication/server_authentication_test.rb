# typed: false
require_relative '../test'

class Vonage::NetworkAuthentication::ServerAuthenticationTest < Vonage::Test
  def server_authentication
    Vonage::NetworkAuthentication::ServerAuthentication.new(config)
  end

  def token_uri
    "https://api-eu.vonage.com/oauth2/token"
  end

  def bc_authorize_uri
    "https://api-eu.vonage.com/oauth2/bc-authorize"
  end

  def example_purpose
    'FraudPreventionAndDetection'
  end

  def example_api_scope
    'check-sim-swap'
  end

  def example_login_hint
    '+447700900000'
  end

  def test_bc_authorize_method
    request_params = {
      scope: "openid dpv:#{example_purpose}##{example_api_scope}",
      login_hint: example_login_hint
    }

    stub_request(:post, bc_authorize_uri).with(request(body: request_params, headers: headers)).to_return(network_authentication_oicd_response)

    response = server_authentication.bc_authorize(purpose: example_purpose, api_scope: example_api_scope, login_hint: example_login_hint)

    assert_kind_of Vonage::Response, response
    assert_equal network_authentication_auth_request_id, response.auth_req_id
  end

  def test_bc_authorize_method_without_purpose
    assert_raises(ArgumentError) { server_authentication.bc_authorize(api_scope: example_api_scope, login_hint: example_login_hint) }
  end

  def test_bc_authorize_method_without_api_scope
    assert_raises(ArgumentError) { server_authentication.bc_authorize(purpose: example_purpose, login_hint: example_login_hint) }
  end

  def test_bc_authorize_method_without_login_hint
    assert_raises(ArgumentError) { server_authentication.bc_authorize(purpose: example_purpose, api_scope: example_api_scope) }
  end

  def test_request_access_token_method
    request_params = {
      grant_type: 'urn:openid:params:grant-type:ciba',
      auth_req_id: network_authentication_auth_request_id
    }

    stub_request(:post, token_uri).with(request(body: request_params, headers: headers)).to_return(network_authentication_token_response)

    response = server_authentication.request_access_token(auth_req_id: network_authentication_auth_request_id)

    assert_kind_of Vonage::Response, response
    assert_equal sample_webhook_token, response.access_token
  end

  def test_request_access_token_method_without_auth_req_id
    assert_raises(ArgumentError) { server_authentication.request_access_token }
  end

  def test_token_method
    bc_authorize_request_params = {
      scope: "openid dpv:#{example_purpose}##{example_api_scope}",
      login_hint: example_login_hint
    }

    request_access_token_request_params = {
      grant_type: 'urn:openid:params:grant-type:ciba',
      auth_req_id: network_authentication_auth_request_id
    }

    stub_request(:post, bc_authorize_uri).with(request(body: bc_authorize_request_params, headers: headers)).to_return(network_authentication_oicd_response)
    stub_request(:post, token_uri).with(request(body: request_access_token_request_params, headers: headers)).to_return(network_authentication_token_response)

    assert_equal sample_webhook_token, server_authentication.token(purpose: example_purpose, api_scope: example_api_scope, login_hint: example_login_hint)
  end

  def test_token_method_without_purpose
    assert_raises(ArgumentError) { server_authentication.token(api_scope: example_api_scope, login_hint: example_login_hint) }
  end

  def test_token_method_without_api_scope
    assert_raises(ArgumentError) { server_authentication.token(purpose: example_purpose, login_hint: example_login_hint) }
  end

  def test_token_method_without_login_hint
    assert_raises(ArgumentError) { server_authentication.token(purpose: example_purpose, api_scope: example_api_scope) }
  end
end
