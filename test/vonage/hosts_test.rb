# typed: false
require_relative './test'

class Vonage::HostsTest < Vonage::Test
  def api_host
    'api-sg-1.nexmo.com'
  end

  def rest_host
    'rest-nexmo-com-xxx.curlhub.io'
  end

  def authorization
    basic_authorization
  end

  def test_custom_api_host
    secrets = Vonage::Secrets.new(config.merge(api_host: api_host))

    uri = %r{\Ahttps://#{api_host}/}

    stub_request(:get, uri).with(request).to_return(secrets_response)

    response = secrets.list

    response.each{|resp| assert_kind_of Vonage::Secrets::ListResponse, resp }
  end

  def test_custom_rest_host
    account = Vonage::Account.new(config.merge(rest_host: rest_host))

    uri = %r{\Ahttps://#{rest_host}/}

    stub_request(:get, uri).with(query: api_key_and_secret).to_return(response)

    assert_kind_of Vonage::Response, account.balance
  end
end
