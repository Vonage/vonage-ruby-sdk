# typed: false
require_relative '../test'

class Vonage::NetworkAuthentication::ClientAuthenticationTest < Vonage::Test
  def client_authentication
    Vonage::NetworkAuthentication::ClientAuthentication.new(config)
  end

  def token_uri
    "https://api-eu.vonage.com/oauth2/token"
  end

  def example_oidc_auth_code
    '0dadaeb4-7c79-4d39-b4b0-5a6cc08bf537'
  end

  def example_purpose
    'FraudPreventionAndDetection'
  end

  def example_api_scope
    'number-verification-verify-read'
  end

  def example_login_hint
    '+447700900000'
  end

  def example_redirect_uri
    'https://example.com/callback'
  end

  def test_token_method
    request_params = {
      grant_type: 'authorization_code',
      code: example_oidc_auth_code,
      redirect_uri: example_redirect_uri
    }

    stub_request(:post, token_uri).with(request(body: request_params, headers: headers)).to_return(network_authentication_token_response)

    assert_equal sample_webhook_token, client_authentication.token(oidc_auth_code: example_oidc_auth_code, redirect_uri: example_redirect_uri)
  end

  def test_token_method_without_oidc_auth_code
    assert_raises(ArgumentError) { client_authentication.token(redirect_uri: example_redirect_uri) }
  end

  def test_token_method_without_redirect_uri
    assert_raises(ArgumentError) { client_authentication.token(oidc_auth_code: example_oidc_auth_code) }
  end

  def test_generate_oidc_uri_method
    uri = client_authentication.generate_oidc_uri(
      purpose: example_purpose,
      api_scope: example_api_scope,
      login_hint: example_login_hint,
      redirect_uri: example_redirect_uri
    )

    assert_equal "https://oidc.idp.vonage.com/oauth2/auth?client_id=#{application_id}&response_type=code&scope=openid+dpv:#{example_purpose}##{example_api_scope}&login_hint=#{example_login_hint}&redirect_uri=#{example_redirect_uri}", uri
  end

  def test_generate_oidc_uri_method_with_optional_params
    uri = client_authentication.generate_oidc_uri(
      purpose: example_purpose,
      api_scope: example_api_scope,
      login_hint: example_login_hint,
      redirect_uri: example_redirect_uri,
      state: '12345'
    )

    assert_equal "https://oidc.idp.vonage.com/oauth2/auth?client_id=#{application_id}&response_type=code&scope=openid+dpv:#{example_purpose}##{example_api_scope}&login_hint=#{example_login_hint}&redirect_uri=#{example_redirect_uri}&state=12345", uri
  end

  def test_generate_oidc_uri_method_without_purpose
    assert_raises(ArgumentError) { client_authentication.generate_oidc_uri(api_scope: example_api_scope, login_hint: example_login_hint, redirect_uri: example_redirect_uri) }
  end

  def test_generate_oidc_uri_method_without_api_scope
    assert_raises(ArgumentError) { client_authentication.generate_oidc_uri(purpose: example_purpose, login_hint: example_login_hint, redirect_uri: example_redirect_uri) }
  end

  def test_generate_oidc_uri_method_without_login_hint
    assert_raises(ArgumentError) { client_authentication.generate_oidc_uri(purpose: example_purpose, api_scope: example_api_scope, redirect_uri: example_redirect_uri) }
  end

  def test_generate_oidc_uri_method_without_redirect_uri
    assert_raises(ArgumentError) { client_authentication.generate_oidc_uri(purpose: example_purpose, api_scope: example_api_scope, login_hint: example_login_hint) }
  end
end
