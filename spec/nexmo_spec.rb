require 'minitest/autorun'
require 'mocha'

require_relative '../lib/nexmo'

describe Nexmo::Client do
  before do
    @client = Nexmo::Client.new('key', 'secret')
  end

  it 'uses ssl by default' do
    assert @client.http.use_ssl?
  end

  it 'allows access to headers' do
    @client.headers.must_be_kind_of(Hash)
  end

  it 'allows to setup auth configuration for all clients' do
    expected_configs = {key: 'newkey', secret: 'newsecret'}
    Nexmo.auth = expected_configs
    assert_equal expected_configs, Nexmo.auth
  end

  it 'raises error when there is no auth configs for client' do
    Nexmo.auth = nil
    assert_raises Nexmo::InvalidAuthError do
      @client = Nexmo::Client.new
    end
  end

  describe '#send_message' do
    it 'makes the correct http call' do
      http_response = stub(:body => '{"messages":[{"status":0,"message-id":"id"}]}')

      data = 'from=ruby&to=number&text=Hey%21&username=key&password=secret'

      headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

      @client.http.expects(:post).with('/sms/json', data, headers).returns(http_response)

      response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})

      assert response.success?
    end

    it 'uses auth configs if given' do
      Nexmo.auth = {key: 'newkey', secret: 'newsecret'}
      @client = Nexmo::Client.new

      http_response = stub(:body => '{"messages":[{"status":0,"message-id":"id"}]}')

      data = 'from=ruby&to=number&text=Hey%21&username=newkey&password=newsecret'

      headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

      @client.http.expects(:post).with('/sms/json', data, headers).returns(http_response)

      response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})

      assert response.success?
    end
  end
end
