require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/setup'
require 'nexmo'
require 'json'

describe 'Nexmo::Client' do
  before do
    @base_url = 'https://rest.nexmo.com'

    @json_object = {:body => /\{".+?":".+?"(,".+?":".+?")+\}/, :headers => {'Content-Type' => 'application/json'}}

    @example_message_hash = {:from => 'ruby', :to => 'number', :text => 'Hey!'}

    @client = Nexmo::Client.new(key: 'key', secret: 'secret')
  end

  describe 'http method' do
    it 'returns a net http object that uses ssl' do
      @client.http.must_be_instance_of(Net::HTTP)

      @client.http.use_ssl?.must_equal(true)
    end
  end

  describe 'send_message method' do
    it 'posts to the sms json resource and returns a response object' do
      stub_request(:post, "#@base_url/sms/json").with(@json_object)

      @client.send_message(@example_message_hash).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'send_message bang method' do
    before do
      @http_response = stub(:code => '200', :[] => 'application/json;charset=utf-8')
    end

    it 'posts to the sms json resource and returns the message id' do
      stub_request(:post, "#@base_url/sms/json").with(@json_object).to_return({
        :headers => {'Content-Type' => 'application/json'},
        :body => '{"messages":[{"status":0,"message-id":"id"}]}'
      })

      @client.send_message!(@example_message_hash).must_equal('id')
    end

    it 'raises an exception if the response code is not expected' do
      stub_request(:post, "#@base_url/sms/json").with(@json_object).to_return(:status => 500)

      proc { @client.send_message!(@example_message_hash) }.must_raise(Nexmo::Error)
    end

    it 'raises an exception if the response body contains an error' do
      stub_request(:post, "#@base_url/sms/json").with(@json_object).to_return({
        :headers => {'Content-Type' => 'application/json'},
        :body => '{"messages":[{"status":2,"error-text":"Missing from param"}]}'
      })

      proc { @client.send_message!(@example_message_hash) }.must_raise(Nexmo::Error)
    end
  end

  describe 'get_balance method' do
    it 'fetches the account balance resource and returns a response object' do
      stub_request(:get, "#@base_url/account/get-balance?api_key=key&api_secret=secret")

      @client.get_balance.must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_country_pricing method' do
    it 'fetches the outbound pricing resource for the given country and returns a response object' do
      stub_request(:get, "#@base_url/account/get-pricing/outbound?api_key=key&api_secret=secret&country=CA")

      @client.get_country_pricing(:CA).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_prefix_pricing method' do
    it 'fetches the outbound pricing resource for the given prefix and returns a response object' do
      stub_request(:get, "#@base_url/account/get-prefix-pricing/outbound?api_key=key&api_secret=secret&prefix=44")

      @client.get_prefix_pricing(44).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_account_numbers method' do
    it 'fetches the account numbers resource with the given parameters and returns a response object' do
      stub_request(:get, "#@base_url/account/numbers?api_key=key&api_secret=secret&size=25&pattern=33")

      @client.get_account_numbers(:size => 25, :pattern => 33).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'number_search method' do
    it 'fetches the number search resource for the given country with the given parameters and returns a response object' do
      stub_request(:get, "#@base_url/number/search?api_key=key&api_secret=secret&country=CA&size=25")

      @client.number_search(:CA, :size => 25).must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'buy_number method' do
    it 'purchases the number requested with the given parameters and returns a response object' do
      stub_request(:post, "#@base_url/number/buy").with(@json_object)

      @client.buy_number(:country => 'US', :msisdn => 'number').must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'cancel_number method' do
    it 'cancels the number requested with the given parameters and returns a response object' do
      stub_request(:post, "#@base_url/number/cancel").with(@json_object)

      @client.cancel_number(:country => 'US', :msisdn => 'number').must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'update_number method' do
    it 'updates the number requested with the given parameters and returns a response object' do
      stub_request(:post, "#@base_url/number/update").with(@json_object)

      @client.update_number(:country => 'US', :msisdn => 'number', :moHttpUrl => 'callback').must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_message method' do
    it 'fetches the message search resource for the given message id and returns a response object' do
      stub_request(:get, "#@base_url/search/message?api_key=key&api_secret=secret&id=00A0B0C0")

      @client.get_message('00A0B0C0').must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'get_message_rejections method' do
    it 'fetches the message rejections resource with the given parameters and returns a response object' do
      stub_request(:get, "#@base_url/search/rejections?api_key=key&api_secret=secret&date=YYYY-MM-DD")

      @client.get_message_rejections(:date => 'YYYY-MM-DD').must_be_instance_of(Nexmo::Response)
    end
  end

  describe 'search_messages method' do
    it 'fetches the search messages resource with the given parameters and returns a response object' do
      stub_request(:get, "#@base_url/search/messages?api_key=key&api_secret=secret&date=YYYY-MM-DD&to=1234567890")

      @client.search_messages(:date => 'YYYY-MM-DD', :to => 1234567890).must_be_instance_of(Nexmo::Response)
    end

    it 'should encode a non hash argument as a list of ids' do
      stub_request(:get, "#@base_url/search/messages?api_key=key&api_secret=secret&ids=id1&ids=id2")

      @client.search_messages(%w(id1 id2))
    end
  end

  it 'provides an option for specifying a different hostname to connect to' do
    @client = Nexmo::Client.new(key: 'key', secret: 'secret', host: 'rest-sandbox.nexmo.com')

    @client.http.address.must_equal('rest-sandbox.nexmo.com')
  end
end

describe 'Nexmo::Response' do
  before do
    @http_response = mock()

    @response = Nexmo::Response.new(@http_response)
  end

  it 'delegates to the underlying http response' do
    @http_response.expects(:code).returns('200')

    @response.must_respond_to(:code)
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

  describe 'object equals method' do
    it 'sets the object to be returned by the object method' do
      @object = stub

      @response.object = @object

      @response.object.must_equal(@object)
    end
  end
end
