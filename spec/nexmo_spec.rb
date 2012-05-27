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

    it 'should make the correct http call and return a success object if the first message status equals 0' do
      http_response = stub(:code => '200', :body => '{"messages":[{"status":0,"message-id":"id"}]}')
      http_response.expects(:[]).with('Content-Type').returns('application/json;charset=utf-8')

      data = 'from=ruby&to=number&text=Hey%21&username=key&password=secret'

      @client.http.expects(:post).with('/sms/json', data, @headers).returns(http_response)

      response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})

      response.success?.must_equal(true)
      response.failure?.must_equal(false)
      response.message_id.must_equal('id')
    end

    it 'should return a failure object if the first message status does not equal 0' do
      http_response = stub(:code => '200', :body => '{"messages":[{"status":2,"error-text":"Missing from param"}]}')
      http_response.expects(:[]).with('Content-Type').returns('application/json')

      data = 'to=number&text=Hey%21&username=key&password=secret'

      @client.http.expects(:post).with('/sms/json', data, @headers).returns(http_response)

      response = @client.send_message({to: 'number', text: 'Hey!'})

      response.success?.must_equal(false)
      response.failure?.must_equal(true)
      response.error.to_s.must_equal('Missing from param (status=2)')
      response.http.wont_be_nil
    end

    it 'should return a failure object if the server returns an unexpected http response' do
      http_response = stub(:code => '503')

      data = 'from=ruby&to=number&text=Hey%21&username=key&password=secret'

      @client.http.expects(:post).with('/sms/json', data, @headers).returns(http_response)

      response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})

      response.success?.must_equal(false)
      response.failure?.must_equal(true)
      response.error.to_s.must_equal('Unexpected HTTP response (code=503)')
      response.http.wont_be_nil
    end
  end
end
