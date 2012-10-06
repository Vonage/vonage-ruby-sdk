require 'minitest/autorun'
require 'mocha'

require_relative '../lib/nexmo'

describe Nexmo::Client do
  before do
    @client = Nexmo::Client.new('key', 'secret')
  end

  describe 'http method' do
    it 'returns a net http object that uses ssl' do
      @client.http.must_be_instance_of(Net::HTTP)
      @client.http.use_ssl?.must_equal(true)
    end
  end

  describe 'headers method' do
    it 'returns a hash' do
      @client.headers.must_be_kind_of(Hash)
    end
  end

  describe 'send_message method' do
    it 'posts to the sms resource' do
      http_response = stub(code: '200', body: '{"messages":[{"status":0,"message-id":"id"}]}')
      http_response.expects(:[]).with('Content-Type').returns('application/json;charset=utf-8')

      data = 'from=ruby&to=number&text=Hey%21&username=key&password=secret'

      headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

      @client.http.expects(:post).with('/sms/json', data, headers).returns(http_response)

      @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})
    end

    describe 'when the first message status equals 0' do
      it 'returns a success object' do
        http_response = stub(code: '200', body: '{"messages":[{"status":0,"message-id":"id"}]}')
        http_response.expects(:[]).with('Content-Type').returns('application/json;charset=utf-8')

        @client.http.stubs(:post).returns(http_response)

        response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})
        response.success?.must_equal(true)
        response.failure?.must_equal(false)
        response.message_id.must_equal('id')
      end
    end

    describe 'when the first message status does not equal 0' do
      it 'returns a failure object' do
        http_response = stub(code: '200', body: '{"messages":[{"status":2,"error-text":"Missing from param"}]}')
        http_response.expects(:[]).with('Content-Type').returns('application/json')

        @client.http.stubs(:post).returns(http_response)

        response = @client.send_message({to: 'number', text: 'Hey!'})

        response.success?.must_equal(false)
        response.failure?.must_equal(true)
        response.error.to_s.must_equal('Missing from param (status=2)')
        response.http.wont_be_nil
      end
    end

    describe 'when the server returns an unexpected http response' do
      it 'returns a failure object' do
        @client.http.stubs(:post).returns(stub(code: '503'))

        response = @client.send_message({from: 'ruby', to: 'number', text: 'Hey!'})

        response.success?.must_equal(false)
        response.failure?.must_equal(true)
        response.error.to_s.must_equal('Unexpected HTTP response (code=503)')
        response.http.wont_be_nil
      end
    end
  end

  describe 'get_balance method' do
    it 'fetches the account balance resource and returns a response object' do
      @client.http.expects(:get).with('/account/get-balance/key/secret').returns(stub)

      @client.get_balance.must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_country_pricing method' do
    it 'fetches the outbound pricing resource for the given country and returns a response object' do
      @client.http.expects(:get).with('/account/get-pricing/outbound/key/secret/CA').returns(stub)

      @client.get_country_pricing(:CA).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_prefix_pricing method' do
    it 'fetches the outbound pricing resource for the given prefix and returns a response object' do
      @client.http.expects(:get).with('/account/get-prefix-pricing/outbound/key/secret/44').returns(stub)

      @client.get_prefix_pricing(44).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_account_numbers method' do
    it 'fetches the account numbers resource with the given parameters and returns a response object' do
      @client.http.expects(:get).with('/account/numbers/key/secret?size=25&pattern=33').returns(stub)

      @client.get_account_numbers(size: 25, pattern: 33).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'number_search method' do
    it 'fetches the number search resource for the given country with the given parameters and returns a response object' do
      @client.http.expects(:get).with('/number/search/key/secret/CA?size=25').returns(stub)

      @client.number_search(:CA, size: 25).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_message method' do
    it 'fetches the message search resource for the given message id and returns a response object' do
      @client.http.expects(:get).with('/search/message/key/secret/00A0B0C0').returns(stub)

      @client.get_message('00A0B0C0').must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_message_rejections method' do
    it 'fetches the message rejections resource with the given parameters and returns a response object' do
      @client.http.expects(:get).with('/search/rejections/key/secret?date=YYYY-MM-DD').returns(stub)

      @client.get_message_rejections(date: 'YYYY-MM-DD').must_be_instance_of(Nexmo::Response)
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
