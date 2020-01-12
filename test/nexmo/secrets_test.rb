# typed: false
require_relative './test'

class Nexmo::SecretsTest < Nexmo::Test
  def secrets
    Nexmo::Secrets.new(config)
  end

  def account_id
    api_key
  end

  def secret_id
    'xx-xx-xx-xx'
  end

  def secrets_uri
    "https://api.nexmo.com/accounts/#{account_id}/secrets"
  end

  def secret_uri
    "https://api.nexmo.com/accounts/#{account_id}/secrets/#{secret_id}"
  end

  def authorization
    basic_authorization
  end

  def test_create_method
    params = {secret: 'F00b4rb4z'}

    stub_request(:post, secrets_uri).with(request(body: params)).to_return(response)

    assert_kind_of Nexmo::Response, secrets.create(params)
  end

  def test_list_method
    stub_request(:get, secrets_uri).with(request).to_return(response)

    assert_kind_of Nexmo::Secrets::ListResponse, secrets.list
  end

  def test_get_method
    stub_request(:get, secret_uri).with(request).to_return(response)

    assert_kind_of Nexmo::Response, secrets.get(secret_id)
  end

  def test_revoke_method
    stub_request(:delete, secret_uri).with(request).to_return(status: 204)

    assert_kind_of Nexmo::Response, secrets.revoke(secret_id)
  end
end
