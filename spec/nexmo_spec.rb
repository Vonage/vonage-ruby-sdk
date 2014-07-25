require 'minitest/autorun'
require 'webmock/minitest'
require 'nexmo'

describe 'Nexmo::Client' do
  def json_response_body(content)
    {headers: {'Content-Type' => 'application/json;charset=utf-8'}, body: content}
  end

  before do
    @base_url = 'https://rest.nexmo.com'

    @form_urlencoded_data = {body: /(.+?)=(.+?)(&(.+?)=(.+?))+/, headers: {'Content-Type' => 'application/x-www-form-urlencoded'}}

    @json_response_body = json_response_body('{"key":"value"}')

    @json_response_object = {'key' => 'value'}

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
    it 'posts to the sms json resource and returns the message id' do
      response_body = json_response_body('{"messages":[{"status":0,"message-id":"id"}]}')

      stub_request(:post, "#@base_url/sms/json").with(@form_urlencoded_data).to_return(response_body)

      @client.send_message(@example_message_hash).must_equal('id')
    end

    it 'raises an exception if the response body contains an error' do
      response_body = json_response_body('{"messages":[{"status":2,"error-text":"Missing from param"}]}')

      stub_request(:post, "#@base_url/sms/json").with(@form_urlencoded_data).to_return(response_body)

      exception = proc { @client.send_message(@example_message_hash) }.must_raise(Nexmo::Error)

      exception.message.must_include('Missing from param')
    end
  end

  describe 'get_balance method' do
    it 'fetches the account balance resource and returns the response object' do
      url = "#@base_url/account/get-balance?api_key=key&api_secret=secret"

      stub_request(:get, url).to_return(@json_response_body)

      @client.get_balance.must_equal(@json_response_object)
    end
  end

  describe 'get_country_pricing method' do
    it 'fetches the outbound pricing resource for the given country and returns the response object' do
      url = "#@base_url/account/get-pricing/outbound?api_key=key&api_secret=secret&country=CA"

      stub_request(:get, url).to_return(@json_response_body)

      @client.get_country_pricing(:CA).must_equal(@json_response_object)
    end
  end

  describe 'get_prefix_pricing method' do
    it 'fetches the outbound pricing resource for the given prefix and returns the response object' do
      url = "#@base_url/account/get-prefix-pricing/outbound?api_key=key&api_secret=secret&prefix=44"

      stub_request(:get, url).to_return(@json_response_body)

      @client.get_prefix_pricing(44).must_equal(@json_response_object)
    end
  end

  describe 'get_account_numbers method' do
    it 'fetches the account numbers resource with the given parameters and returns the response object' do
      url = "#@base_url/account/numbers?api_key=key&api_secret=secret&size=25&pattern=33"

      stub_request(:get, url).to_return(@json_response_body)

      @client.get_account_numbers(:size => 25, :pattern => 33).must_equal(@json_response_object)
    end
  end

  describe 'number_search method' do
    it 'fetches the number search resource for the given country with the given parameters and returns the response object' do
      url = "#@base_url/number/search?api_key=key&api_secret=secret&country=CA&size=25"

      stub_request(:get, url).to_return(@json_response_body)

      @client.number_search(:CA, :size => 25).must_equal(@json_response_object)
    end
  end

  describe 'buy_number method' do
    it 'purchases the number requested with the given parameters and returns the response object' do
      url = "#@base_url/number/buy"

      stub_request(:post, url).with(@form_urlencoded_data).to_return(@json_response_body)

      @client.buy_number(:country => 'US', :msisdn => 'number').must_equal(@json_response_object)
    end
  end

  describe 'cancel_number method' do
    it 'cancels the number requested with the given parameters and returns the response object' do
      url = "#@base_url/number/cancel"

      stub_request(:post, url).with(@form_urlencoded_data).to_return(@json_response_body)

      @client.cancel_number(:country => 'US', :msisdn => 'number').must_equal(@json_response_object)
    end
  end

  describe 'update_number method' do
    it 'updates the number requested with the given parameters and returns the response object' do
      url = "#@base_url/number/update"

      stub_request(:post, url).with(@form_urlencoded_data).to_return(@json_response_body)

      @client.update_number(:country => 'US', :msisdn => 'number', :moHttpUrl => 'callback').must_equal(@json_response_object)
    end
  end

  describe 'get_message method' do
    it 'fetches the message search resource for the given message id and returns the response object' do
      url = "#@base_url/search/message?api_key=key&api_secret=secret&id=00A0B0C0"

      stub_request(:get, url).to_return(@json_response_body)

      @client.get_message('00A0B0C0').must_equal(@json_response_object)
    end
  end

  describe 'get_message_rejections method' do
    it 'fetches the message rejections resource with the given parameters and returns the response object' do
      url = "#@base_url/search/rejections?api_key=key&api_secret=secret&date=YYYY-MM-DD"

      stub_request(:get, url).to_return(@json_response_body)

      @client.get_message_rejections(:date => 'YYYY-MM-DD').must_equal(@json_response_object)
    end
  end

  describe 'search_messages method' do
    it 'fetches the search messages resource with the given parameters and returns the response object' do
      url = "#@base_url/search/messages?api_key=key&api_secret=secret&date=YYYY-MM-DD&to=1234567890"

      stub_request(:get, url).to_return(@json_response_body)

      @client.search_messages(:date => 'YYYY-MM-DD', :to => 1234567890).must_equal(@json_response_object)
    end

    it 'should encode a non hash argument as a list of ids' do
      url = "#@base_url/search/messages?api_key=key&api_secret=secret&ids=id1&ids=id2"

      stub_request(:get, url).to_return(@json_response_body)

      @client.search_messages(%w(id1 id2))
    end
  end

  it 'raises an exception if the response code is not 2xx' do
    stub_request(:post, "#@base_url/sms/json").with(@form_urlencoded_data).to_return(status: 500)

    proc { @client.send_message(@example_message_hash) }.must_raise(Nexmo::Error)
  end

  it 'raises an authentication error exception if the response code is 401' do
    stub_request(:post, "#@base_url/sms/json").with(@form_urlencoded_data).to_return(status: 401)

    proc { @client.send_message(@example_message_hash) }.must_raise(Nexmo::AuthenticationError)
  end

  it 'provides an option for specifying a different hostname to connect to' do
    @client = Nexmo::Client.new(key: 'key', secret: 'secret', host: 'rest-sandbox.nexmo.com')

    @client.http.address.must_equal('rest-sandbox.nexmo.com')
  end
end
