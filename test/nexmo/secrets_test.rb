require_relative './test'

class NexmoSecretsTest < Nexmo::Test
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

    request_stub = stub_request(:post, secrets_uri).with(request(body: params)).to_return(response)

    assert_equal response_object, secrets.create(params)
    assert_requested request_stub
  end

  def test_list_method
    request_stub = stub_request(:get, secrets_uri).with(request).to_return(response)

    assert_equal response_object, secrets.list
    assert_requested request_stub
  end

  def test_get_method
    request_stub = stub_request(:get, secret_uri).with(request).to_return(response)

    assert_equal response_object, secrets.get(secret_id)
    assert_requested request_stub
  end

  def test_revoke_method
    request_stub = stub_request(:delete, secret_uri).with(request).to_return(status: 204)

    assert_equal :no_content, secrets.revoke(secret_id)
    assert_requested request_stub
  end
end
