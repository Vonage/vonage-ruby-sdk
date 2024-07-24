# typed: false
require_relative '../test'

class Vonage::NetworkAuthentication::ClientTest < Vonage::Test
  def client
    Vonage::NetworkAuthentication::Client.new(config)
  end

  def token_uri
    "https://api-eu.vonage.com/oauth2/token"
  end

  def test_token_method
    grant_type = 'authorization_code'
    code = '0dadaeb4-7c79-4d39-b4b0-5a6cc08bf537'
    redirect_uri = 'https://example.com/callback'

    request_params = {
      grant_type: grant_type,
      code: code,
      redirect_uri: redirect_uri
    }

    stub_request(:post, token_uri).with(request(body: request_params, headers: headers)).to_return(response)

    response = client.token(
      grant_type: grant_type,
      oidc_auth_code: code,
      redirect_uri: redirect_uri
    )

    assert_kind_of Vonage::Response, response
  end
end
