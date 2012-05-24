require 'minitest/autorun'
require 'mocha'

require_relative '../lib/nexmo'

describe Nexmo::Client do
  before do
    @client = Nexmo::Client.new('key', 'secret')
  end

  describe 'http method' do
    it 'should return a Net::HTTP object that uses SSL' do
      @client.http.must_be_instance_of(Net::HTTP)
      @client.http.use_ssl?.must_equal(true)
    end
  end

  describe 'headers method' do
    it 'should return a hash' do
      @client.headers.must_be_kind_of(Hash)
    end
  end

  describe 'send_message method' do
    before do
      @headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
    end

    it 'should make the correct http call return a successful response if the first message status equals 0' do
      http_response = stub(:body => '{"messages":[{"status":0,"message-id":"id"}]}')

      data = 'from=ruby&to=number&text=Hey%21&username=key&password=secret'

      @client.http.expects(:post).with('/sms/json', data, @headers).returns(http_response)

      response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})

      response.success?.must_equal(true)
      response.failure?.must_equal(false)
      response.message_id.must_equal('id')
    end

    it 'should return a failure response if the first message status does not equal 0' do
      http_response = stub(:body => '{"messages":[{"status":2,"error-text":"Missing from param"}]}')

      data = 'to=number&text=Hey%21&username=key&password=secret'

      @client.http.expects(:post).with('/sms/json', data, @headers).returns(http_response)

      response = @client.send_message({to: 'number', text: 'Hey!'})

      response.success?.must_equal(false)
      response.failure?.must_equal(true)
      response.error.to_s.must_equal('Missing from param (status=2)')
    end

    it 'should return a failure response if nexmo service returns HTTP ERROR: 500' do
      http_response = stub(:body => '<html>
      <head>
      <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1"/>
      <title>Error 500 Server Error</title>
      </head>
      <body>
      <h2>HTTP ERROR: 500</h2>
      <p>Problem accessing /sms/json. Reason:
      <pre>    Server Error</pre></p>
      <hr /><i><small>Powered by Jetty://</small></i>
      </body>
      </html>')

      data = 'to=number&text=Hey%21&username=key&password=secret'

      @client.http.expects(:post).with('/sms/json', data, @headers).returns(http_response)

      response = @client.send_message({to: 'number', text: 'Hey!'})

      response.success?.must_equal(false)
      response.failure?.must_equal(true)
      response.error.to_s.must_equal('Internal error (status=5)')
    end
  end
end
