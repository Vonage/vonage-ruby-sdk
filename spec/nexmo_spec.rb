require 'minitest/autorun'
require 'mocha'
require 'multi_json'
require 'nexmo'

describe 'Nexmo::Client' do
  before do
    @client = Nexmo::Client.new('key', 'secret')
  end

  describe 'http method' do
    it 'returns a net http object that uses ssl' do
      @client.http.must_be_instance_of(Net::HTTP)
      @client.http.use_ssl?.must_equal(true)
    end
  end

  describe 'send_message method' do
    it 'posts to the sms json resource and returns a response object' do
      data = regexp_matches(/\{".+?":".+?"(,".+?":".+?")+\}/)

      headers = has_entry('Content-Type', 'application/json')

      params = {:from => 'ruby', :to => 'number', :text => 'Hey!'}

      @client.http.expects(:post).with('/sms/json', data, headers).returns(stub)

      @client.send_message(params).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'send_message bang method' do
    before do
      @params = {:from => 'ruby', :to => 'number', :text => 'Hey!'}

      @http_response = mock()
      @http_response.stubs(:[]).with('Content-Type').returns('application/json;charset=utf-8')
      @http_response.stubs(:code).returns('200')
    end

    it 'posts to the sms json resource and returns the message id' do
      data = regexp_matches(/\{".+?":".+?"(,".+?":".+?")+\}/)

      headers = has_entry('Content-Type', 'application/json')

      @http_response.stubs(:body).returns('{"messages":[{"status":0,"message-id":"id"}]}')

      @client.http.expects(:post).with('/sms/json', data, headers).returns(@http_response)

      @client.send_message!(@params).must_equal('id')
    end

    it 'raises an exception if the response code is not expected' do
      @http_response.stubs(:code).returns('500')

      @client.http.stubs(:post).returns(@http_response)

      proc { @client.send_message!(@params) }.must_raise(Nexmo::Error)
    end

    it 'raises an exception if the response body contains an error' do
      @http_response.stubs(:body).returns('{"messages":[{"status":2,"error-text":"Missing from param"}]}')

      @client.http.stubs(:post).returns(@http_response)

      proc { @client.send_message!(@params) }.must_raise(Nexmo::Error)
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
      @client.http.expects(:get).with(has_equivalent_query_string('/account/numbers/key/secret?size=25&pattern=33')).returns(stub)

      @client.get_account_numbers(:size => 25, :pattern => 33).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'number_search method' do
    it 'fetches the number search resource for the given country with the given parameters and returns a response object' do
      @client.http.expects(:get).with('/number/search/key/secret/CA?size=25').returns(stub)

      @client.number_search(:CA, :size => 25).must_be_instance_of(Nexmo::Response)
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

      @client.get_message_rejections(:date => 'YYYY-MM-DD').must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'search_messages method' do
    it 'fetches the search messages resource with the given parameters and returns a response object' do
      @client.http.expects(:get).with(has_equivalent_query_string('/search/messages/key/secret?date=YYYY-MM-DD&to=1234567890')).returns(stub)

      @client.search_messages(:date => 'YYYY-MM-DD', :to => 1234567890).must_be_instance_of(Nexmo::Response)
    end

    it 'should encode a non hash argument as a list of ids' do
      @client.http.expects(:get).with(has_equivalent_query_string('/search/messages/key/secret?ids=id1&ids=id2')).returns(stub)

      @client.search_messages(%w(id1 id2))
    end
  end
end

describe 'Nexmo::Response' do
  before do
    @http_response = mock()

    @response = Nexmo::Response.new(@http_response)
  end

  it 'delegates to the underlying http response' do
    @http_response.expects(:code).returns('200')

    @response.must_respond_to(:code) unless RUBY_VERSION == '1.8.7'
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
    it 'decodes the response body as json and returns a hash' do
      @http_response.expects(:body).returns('{"value":0.0}')

      @response.object.must_equal({'value' => 0})
    end
  end
end

describe 'Nexmo::Response initialized with a different json implementation' do
  before do
    @http_response = mock()

    @response = Nexmo::Response.new(@http_response, :json => MultiJson)
  end

  describe 'object method' do
    it 'decodes the response body as json and returns a hash' do
      @http_response.expects(:body).returns('{"value":0.0}')

      @response.object.must_equal({'value' => 0})
    end
  end
end
