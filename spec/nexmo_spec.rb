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

describe Nexmo::Response do
  before do
    @http_response = mock()

    @response = Nexmo::Response.new(@http_response)
  end

  it 'delegates to the underlying http response' do
    @http_response.expects(:code).returns('200')

    @response.code.must_equal('200')
  end

  describe 'ok query method' do
    it 'returns true if the status code is 200' do
      @http_response.expects(:code).returns('200')

      @response.ok?.must_equal(true)
    end

    it 'returns false otherwise' do
      @http_response.expects(:code).returns('400')

      @response.ok?.must_equal(false)
    end
  end

  describe 'json query method' do
    it 'returns true if the response has a json content type' do
      @http_response.expects(:[]).with('Content-Type').returns('application/json;charset=utf-8')

      @response.json?.must_equal(true)
    end

    it 'returns false otherwise' do
      @http_response.expects(:[]).with('Content-Type').returns('text/html')

      @response.json?.must_equal(false)
    end
  end

  describe 'object method' do
    it 'decodes the response body as json and returns an object' do
      @http_response.expects(:body).returns('{}')

      @response.object.must_be_instance_of(Nexmo::Object)
    end
  end
end

describe Nexmo::Object do
  before do
    @value = 'xxx'

    @object = Nexmo::Object.new(message_id: @value)
  end

  it 'provides method access for attributes passed to the constructor' do
    @object.message_id.must_equal(@value)
  end

  describe 'square brackets method' do
    it 'returns the value of the given attribute' do
      @object[:message_id].must_equal(@value)
    end
  end

  describe 'square brackets equals method' do
    it 'sets the value of the given attribute' do
      @object['message_id'] = 'abc'
      @object.message_id.wont_equal(@value)
    end

    it 'replaces dashes in keys with underscores' do
      @object['message-id'] = 'abc'
      @object.message_id.wont_equal(@value)
    end
  end

  describe 'to_hash method' do
    it 'returns a hash containing the object attributes' do
      @object.to_hash.must_equal({message_id: @value})
    end
  end
end
