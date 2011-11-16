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

  describe '#send_message' do
    it 'makes the correct http call' do
      http_response = stub(:body => '{"messages":[{"status":0,"message-id":"id"}]}')

      data = 'from=ruby&to=number&text=Hey%21&username=key&password=secret'

      headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

      @client.http.expects(:post).with('/sms/json', data, headers).returns(http_response)

      response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})

      assert response.success?
    end
  end
end
