require 'minitest/autorun'
require 'webmock/minitest'
require 'nexmo'

describe 'Nexmo::Client' do
  def json_response_body(content)
    {headers: {'Content-Type' => 'application/json;charset=utf-8'}, body: content}
  end

  before do
    @base_url = 'https://rest.nexmo.com'

    @api_base_url = 'https://api.nexmo.com'

    @form_urlencoded_data = {body: /(.+?)=(.+?)(&(.+?)=(.+?))+/, headers: {'Content-Type' => 'application/x-www-form-urlencoded'}}

    @json_response_body = json_response_body('{"key":"value"}')

    @json_response_object = {'key' => 'value'}

    @example_message_hash = {:from => 'ruby', :to => 'number', :text => 'Hey!'}

    @client = Nexmo::Client.new(key: 'key', secret: 'secret')
  end

  describe 'send_verification_request method' do
    it 'posts to the verify json resource and returns the response object' do
      url = "#@api_base_url/verify/json"

      stub_request(:post, url).with(@form_urlencoded_data).to_return(@json_response_body)

      @client.send_verification_request(number: '447525856424', brand: 'MyApp')
    end
  end

  describe 'check_verification_request method' do
    it 'posts to the verify json resource and returns the response object' do
      url = "#@api_base_url/verify/check/json"

      stub_request(:post, url).with(@form_urlencoded_data).to_return(@json_response_body)

      @client.check_verification_request(request_id: '8g88g88eg8g8gg9g90', code: '123445')
    end
  end

  describe 'get_verification_request method' do
    it 'fetches the verify search resource with the given request id and returns the response object' do
      url = "#@api_base_url/verify/search/json?api_key=key&api_secret=secret&request_id=8g88g88eg8g8gg9g90"

      stub_request(:get, url).to_return(@json_response_body)

      @client.get_verification_request('8g88g88eg8g8gg9g90')
    end
  end

  describe 'control_verification_request method' do
    it 'posts to the control json resource and returns the response object' do
      url = "#@api_base_url/verify/control/json"

      stub_request(:post, url).with(@form_urlencoded_data).to_return(@json_response_body)

      @client.control_verification_request(request_id: '8g88g88eg8g8gg9g90', cmd: 'cancel')
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
    url = "https://rest-sandbox.nexmo.com/account/get-balance?api_key=key&api_secret=secret"

    request = stub_request(:get, url).to_return(@json_response_body)

    @client = Nexmo::Client.new(key: 'key', secret: 'secret', host: 'rest-sandbox.nexmo.com')

    @client.get_balance

    assert_requested(request)
  end
end
