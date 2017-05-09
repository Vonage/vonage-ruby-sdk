require 'minitest/autorun'
require 'webmock/minitest'
require 'nexmo'

describe 'Nexmo::Client' do
  before do
    @api_key = 'api_key_xxx'

    @api_secret = 'api_secret_xxx'

    @application_id = 'nexmo-application-id'

    @private_key = File.read('test/private_key.txt')

    @base_url = 'https://rest.nexmo.com'

    @api_base_url = 'https://api.nexmo.com'

    @response_body = {body: '{"key":"value"}', headers: {'Content-Type' => 'application/json;charset=utf-8'}}

    @response_object = Nexmo::Entity.new(key: 'value')

    @client = Nexmo::Client.new(key: @api_key, secret: @api_secret, application_id: @application_id, private_key: @private_key)
  end

  let(:authorization_header) { {'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/} }

  let(:recording_id) { 'xx-xx-xx-xx' }

  let(:recording_url) { "#@api_base_url/v1/files/xx-xx-xx-xx" }

  let(:recording_content) { 'BODY' }

  let(:recording_response) { {body: recording_content, headers: {'Content-Type' => 'application/octet-stream'}} }

  let(:recording_filename) { 'test/file.mp3' }

  describe 'send_message method' do
    it 'posts to the sms resource and returns the response object' do
      expect_post "#@base_url/sms/json", "from=ruby&to=number&text=Hey!&api_key=#@api_key&api_secret=#@api_secret"

      @client.send_message(from: 'ruby', to: 'number', text: 'Hey!').must_equal(@response_object)
    end
  end

  describe 'track_message_conversion method' do
    it 'posts to the sms conversions resource and returns the response object' do
      expect_post "#@api_base_url/conversions/sms", "message-id=12345&delivered=true&api_key=#@api_key&api_secret=#@api_secret"

      @client.track_message_conversion('12345', delivered: true).must_equal(@response_object)
    end
  end

  describe 'track_voice_conversion method' do
    it 'posts to the voice conversions resource and returns the response object' do
      expect_post "#@api_base_url/conversions/voice", "message-id=12345&delivered=true&api_key=#@api_key&api_secret=#@api_secret"

      @client.track_voice_conversion('12345', delivered: true).must_equal(@response_object)
    end
  end

  describe 'get_balance method' do
    it 'fetches the account balance resource and returns the response object' do
      expect_get "#@base_url/account/get-balance?api_key=#@api_key&api_secret=#@api_secret"

      @client.get_balance.must_equal(@response_object)
    end
  end

  describe 'get_country_pricing method' do
    it 'fetches the outbound pricing resource for the given country and returns the response object' do
      expect_get "#@base_url/account/get-pricing/outbound?api_key=#@api_key&api_secret=#@api_secret&country=CA"

      @client.get_country_pricing(:CA).must_equal(@response_object)
    end
  end

  describe 'get_prefix_pricing method' do
    it 'fetches the outbound pricing resource for the given prefix and returns the response object' do
      expect_get "#@base_url/account/get-prefix-pricing/outbound?api_key=#@api_key&api_secret=#@api_secret&prefix=44"

      @client.get_prefix_pricing(44).must_equal(@response_object)
    end
  end

  describe 'get_sms_pricing method' do
    it 'fetches the outbound sms pricing resource for the given phone number and returns the response object' do
      expect_get "#@base_url/account/get-phone-pricing/outbound/sms?api_key=#@api_key&api_secret=#@api_secret&phone=447525856424"

      @client.get_sms_pricing('447525856424').must_equal(@response_object)
    end
  end

  describe 'get_voice_pricing method' do
    it 'fetches the outbound voice pricing resource for the given phone number and returns the response object' do
      expect_get "#@base_url/account/get-phone-pricing/outbound/voice?api_key=#@api_key&api_secret=#@api_secret&phone=447525856424"

      @client.get_voice_pricing('447525856424').must_equal(@response_object)
    end
  end

  describe 'update_settings method' do
    it 'updates the account settings resource with the given parameters and returns the response object' do
      expect_post "#@base_url/account/settings", "api_key=#@api_key&api_secret=#@api_secret&moCallBackUrl=http://example.com/callback"

      @client.update_settings(moCallBackUrl: 'http://example.com/callback').must_equal(@response_object)
    end
  end

  describe 'topup method' do
    it 'updates the account top-up resource with the given parameters and returns the response object' do
      expect_post "#@base_url/account/top-up", "api_key=#@api_key&api_secret=#@api_secret&trx=00X123456Y7890123Z"

      @client.topup(trx: '00X123456Y7890123Z').must_equal(@response_object)
    end
  end

  describe 'get_account_numbers method' do
    it 'fetches the account numbers resource with the given parameters and returns the response object' do
      expect_get "#@base_url/account/numbers?api_key=#@api_key&api_secret=#@api_secret&size=25&pattern=33"

      @client.get_account_numbers(size: 25, pattern: 33).must_equal(@response_object)
    end
  end

  describe 'get_available_numbers method' do
    it 'fetches the number search resource with the given parameters and returns the response object' do
      expect_get "#@base_url/number/search?api_key=#@api_key&api_secret=#@api_secret&country=CA&size=25"

      @client.get_available_numbers('CA', size: 25).must_equal(@response_object)
    end
  end

  describe 'buy_number method' do
    it 'purchases the number requested with the given parameters and returns the response object' do
      expect_post "#@base_url/number/buy", "api_key=#@api_key&api_secret=#@api_secret&country=US&msisdn=number"

      @client.buy_number(country: 'US', msisdn: 'number').must_equal(@response_object)
    end
  end

  describe 'cancel_number method' do
    it 'cancels the number requested with the given parameters and returns the response object' do
      expect_post "#@base_url/number/cancel", "api_key=#@api_key&api_secret=#@api_secret&country=US&msisdn=number"

      @client.cancel_number(country: 'US', msisdn: 'number').must_equal(@response_object)
    end
  end

  describe 'update_number method' do
    it 'updates the number requested with the given parameters and returns the response object' do
      expect_post "#@base_url/number/update", "api_key=#@api_key&api_secret=#@api_secret&country=US&msisdn=number&moHttpUrl=callback"

      @client.update_number(country: 'US', msisdn: 'number', moHttpUrl: 'callback').must_equal(@response_object)
    end
  end

  describe 'get_message method' do
    it 'fetches the message search resource for the given message id and returns the response object' do
      expect_get "#@base_url/search/message?api_key=#@api_key&api_secret=#@api_secret&id=00A0B0C0"

      @client.get_message('00A0B0C0').must_equal(@response_object)
    end
  end

  describe 'get_message_rejections method' do
    it 'fetches the message rejections resource with the given parameters and returns the response object' do
      expect_get "#@base_url/search/rejections?api_key=#@api_key&api_secret=#@api_secret&date=YYYY-MM-DD"

      @client.get_message_rejections(date: 'YYYY-MM-DD').must_equal(@response_object)
    end
  end

  describe 'search_messages method' do
    it 'fetches the search messages resource with the given parameters and returns the response object' do
      expect_get "#@base_url/search/messages?api_key=#@api_key&api_secret=#@api_secret&date=YYYY-MM-DD&to=1234567890"

      @client.search_messages(date: 'YYYY-MM-DD', to: 1234567890).must_equal(@response_object)
    end

    it 'should encode a non hash argument as a list of ids' do
      expect_get "#@base_url/search/messages?api_key=#@api_key&api_secret=#@api_secret&ids=id1&ids=id2"

      @client.search_messages(%w(id1 id2))
    end
  end

  describe 'send_2fa_message method' do
    it 'posts to the short code two factor authentication resource and returns the response object' do
      expect_post "#@base_url/sc/us/2fa/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&pin=1234"

      @client.send_2fa_message(to: '16365553226', pin: 1234).must_equal(@response_object)
    end
  end

  describe 'send_event_alert_message method' do
    it 'posts to the short code alert resource and returns the response object' do
      expect_post "#@base_url/sc/us/alert/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&server=host&link=http://example.com/"

      @client.send_event_alert_message(to: '16365553226', server: 'host', link: 'http://example.com/').must_equal(@response_object)
    end
  end

  describe 'send_marketing_message method' do
    it 'posts to the short code marketing resource and returns the response object' do
      expect_post "#@base_url/sc/us/marketing/json", "api_key=#@api_key&api_secret=#@api_secret&from=666&to=16365553226&keyword=NEXMO&text=Hello"

      @client.send_marketing_message(from: '666', to: '16365553226', keyword: 'NEXMO', text: 'Hello').must_equal(@response_object)
    end
  end

  describe 'get_event_alert_numbers method' do
    it 'fetches the short code alert opt-in query resource and returns the response object' do
      expect_get "#@base_url/sc/us/alert/opt-in/query/json?api_key=#@api_key&api_secret=#@api_secret"

      @client.get_event_alert_numbers.must_equal(@response_object)
    end
  end

  describe 'resubscribe_event_alert_number method' do
    it 'posts to the short code alert opt-in manage resource and returns the response object' do
      expect_post "#@base_url/sc/us/alert/opt-in/manage/json", "api_key=#@api_key&api_secret=#@api_secret&msisdn=441632960960"

      @client.resubscribe_event_alert_number(msisdn: '441632960960').must_equal(@response_object)
    end
  end

  describe 'initiate_call method' do
    it 'posts to the call resource and returns the response object' do
      expect_post "#@base_url/call/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&answer_url=http://example.com/answer"

      Kernel.stub :warn, proc { |message| message.must_match(/initiate_call is deprecated/) } do
        @client.initiate_call(to: '16365553226', answer_url: 'http://example.com/answer').must_equal(@response_object)
      end
    end
  end

  describe 'initiate_tts_call method' do
    it 'posts to the tts resource and returns the response object' do
      expect_post "#@api_base_url/tts/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&text=Hello"

      Kernel.stub :warn, proc { |message| message.must_match(/initiate_tts_call is deprecated/) } do
        @client.initiate_tts_call(to: '16365553226', text: 'Hello').must_equal(@response_object)
      end
    end
  end

  describe 'initiate_tts_prompt_call method' do
    it 'posts to the tts prompt resource and returns the response object' do
      expect_post "#@api_base_url/tts-prompt/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&text=Hello&max_digits=4&bye_text=Goodbye"

      Kernel.stub :warn, proc { |message| message.must_match(/initiate_tts_prompt_call is deprecated/) } do
        @client.initiate_tts_prompt_call(to: '16365553226', text: 'Hello', max_digits: 4, bye_text: 'Goodbye').must_equal(@response_object)
      end
    end
  end

  describe 'start_verification method' do
    it 'posts to the verify json resource and returns the response object' do
      expect_post "#@api_base_url/verify/json", "api_key=#@api_key&api_secret=#@api_secret&number=447525856424&brand=MyApp"

      @client.start_verification(number: '447525856424', brand: 'MyApp').must_equal(@response_object)
    end
  end

  describe 'check_verification method' do
    it 'posts to the verify check resource and returns the response object' do
      expect_post "#@api_base_url/verify/check/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&code=123445"

      @client.check_verification('8g88g88eg8g8gg9g90', code: '123445').must_equal(@response_object)
    end
  end

  describe 'get_verification method' do
    it 'fetches the verify search resource with the given request id and returns the response object' do
      expect_get "#@api_base_url/verify/search/json?api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90"

      @client.get_verification('8g88g88eg8g8gg9g90').must_equal(@response_object)
    end
  end

  describe 'cancel_verification method' do
    it 'posts to the verify control resource and returns the response object' do
      expect_post "#@api_base_url/verify/control/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&cmd=cancel"

      @client.cancel_verification('8g88g88eg8g8gg9g90').must_equal(@response_object)
    end
  end

  describe 'trigger_next_verification_event method' do
    it 'posts to the verify control resource and returns the response object' do
      expect_post "#@api_base_url/verify/control/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&cmd=trigger_next_event"

      @client.trigger_next_verification_event('8g88g88eg8g8gg9g90').must_equal(@response_object)
    end
  end

  describe 'get_basic_number_insight method' do
    it 'fetches the number format resource and returns the response object' do
      expect_get "#@api_base_url/ni/basic/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

      @client.get_basic_number_insight(number: '447525856424').must_equal(@response_object)
    end
  end

  describe 'get_standard_number_insight method' do
    it 'fetches the number lookup resource and returns the response object' do
      expect_get "#@api_base_url/ni/standard/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

      @client.get_standard_number_insight(number: '447525856424').must_equal(@response_object)
    end
  end

  describe 'get_advanced_number_insight method' do
    it 'fetches the ni advanced resource and returns the response object' do
      expect_get "#@api_base_url/ni/advanced/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

      @client.get_advanced_number_insight(number: '447525856424').must_equal(@response_object)
    end
  end

  describe 'get_advanced_async_number_insight method' do
    it 'fetches the ni advanced async resource and returns the response object' do
      expect_get "#@api_base_url/ni/advanced/async/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

      @client.get_advanced_async_number_insight(number: '447525856424').must_equal(@response_object)
    end
  end

  describe 'request_number_insight method' do
    it 'posts to the number insight resource and returns the response object' do
      expect_post "#@base_url/ni/json", "api_key=#@api_key&api_secret=#@api_secret&number=447525856424&callback=https://example.com"

      @client.request_number_insight(number: '447525856424', callback: 'https://example.com').must_equal(@response_object)
    end
  end

  describe 'get_applications method' do
    it 'fetches the applications resource and returns the response object' do
      expect_get "#@api_base_url/v1/applications?api_key=#@api_key&api_secret=#@api_secret"

      @client.get_applications.must_equal(@response_object)
    end
  end

  describe 'get_application method' do
    it 'fetches the application resource with the given id and returns the response object' do
      expect_get "#@api_base_url/v1/applications/xx-xx-xx-xx?api_key=#@api_key&api_secret=#@api_secret"

      @client.get_application('xx-xx-xx-xx').must_equal(@response_object)
    end
  end

  describe 'create_application method' do
    it 'posts to the applications resource and returns the response object' do
      expect_post "#@api_base_url/v1/applications", "api_key=#@api_key&api_secret=#@api_secret&name=Example+App&type=voice"

      @client.create_application(name: 'Example App', type: 'voice')
    end
  end

  describe 'update_application method' do
    it 'puts to the application resource with the given id and returns the response object' do
      expect_put "#@api_base_url/v1/applications/xx-xx-xx-xx", "api_key=#@api_key&api_secret=#@api_secret&answer_url=https%3A%2F%2Fexample.com%2Fncco"

      @client.update_application('xx-xx-xx-xx', answer_url: 'https://example.com/ncco')
    end
  end

  describe 'delete_application method' do
    it 'deletes the application resource with the given id' do
      expect_delete "#@api_base_url/v1/applications/xx-xx-xx-xx?api_key=#@api_key&api_secret=#@api_secret"

      @client.delete_application('xx-xx-xx-xx')
    end
  end

  describe 'create_call method' do
    it 'posts to the calls resource and returns the response object' do
      params = {
        to: [{type: 'phone', number: '14843331234'}],
        from: {type: 'phone', number: '14843335555'},
        answer_url: ['https://example.com/answer']
      }

      expect :post, "#@api_base_url/v1/calls", params

      @client.create_call(params).must_equal(@response_object)
    end
  end

  describe 'get_calls method' do
    it 'fetches the calls resource and returns the response object' do
      expect :get, "#@api_base_url/v1/calls?status=completed"

      @client.get_calls(status: 'completed').must_equal(@response_object)
    end
  end

  describe 'get_call method' do
    it 'fetches the call resource with the given uuid and returns the response object' do
      expect :get, "#@api_base_url/v1/calls/xx-xx-xx-xx"

      @client.get_call('xx-xx-xx-xx').must_equal(@response_object)
    end
  end

  describe 'update_call method' do
    it 'puts to the call resource with the given uuid and returns the response object' do
      expect :put, "#@api_base_url/v1/calls/xx-xx-xx-xx", {action: 'hangup'}

      @client.update_call('xx-xx-xx-xx', action: 'hangup').must_equal(@response_object)
    end
  end

  describe 'send_audio method' do
    it 'puts to the call stream resource with the given uuid and returns the response object' do
      expect :put, "#@api_base_url/v1/calls/xx-xx-xx-xx/stream", {stream_url: 'http://example.com/audio.mp3'}

      @client.send_audio('xx-xx-xx-xx', stream_url: 'http://example.com/audio.mp3').must_equal(@response_object)
    end
  end

  describe 'stop_audio method' do
    it 'deletes the call stream resource with the given uuid' do
      expect :delete, "#@api_base_url/v1/calls/xx-xx-xx-xx/stream"

      @client.stop_audio('xx-xx-xx-xx')
    end
  end

  describe 'send_speech method' do
    it 'puts to the call talk resource with the given uuid and returns the response object' do
      expect :put, "#@api_base_url/v1/calls/xx-xx-xx-xx/talk", {text: 'Hello'}

      @client.send_speech('xx-xx-xx-xx', text: 'Hello').must_equal(@response_object)
    end
  end

  describe 'stop_speech method' do
    it 'deletes the call talk resource with the given uuid' do
      expect :delete, "#@api_base_url/v1/calls/xx-xx-xx-xx/talk"

      @client.stop_speech('xx-xx-xx-xx')
    end
  end

  describe 'send_dtmf method' do
    it 'puts to the call dtmf resource with the given uuid and returns the response object' do
      expect :put, "#@api_base_url/v1/calls/xx-xx-xx-xx/dtmf", {digits: '1234'}

      @client.send_dtmf('xx-xx-xx-xx', digits: '1234').must_equal(@response_object)
    end
  end

  describe 'get_file method' do
    it 'fetches the file resource with the given id and returns the response body' do
      @request = stub_request(:get, recording_url).with(headers: authorization_header).to_return(recording_response)

      @client.get_file(recording_id).must_equal(recording_content)
    end

    it 'fetches the file resource with the given url and returns the response body' do
      @request = stub_request(:get, recording_url).with(headers: authorization_header).to_return(recording_response)

      @client.get_file(recording_url).must_equal(recording_content)
    end
  end

  describe 'save_file method' do
    after { File.unlink(recording_filename) if File.exist?(recording_filename) }

    it 'fetches the file resource with the given id and streams the response body to the given filename' do
      @request = stub_request(:get, recording_url).with(headers: authorization_header).to_return(recording_response)

      @client.save_file(recording_id, recording_filename)

      File.read(recording_filename).must_equal(recording_content)
    end

    it 'fetches the file resource with the given url and streams the response body to the given filename' do
      @request = stub_request(:get, recording_url).with(headers: authorization_header).to_return(recording_response)

      @client.save_file(recording_url, recording_filename)

      File.read(recording_filename).must_equal(recording_content)
    end
  end

  describe 'check_signature method' do
    it 'returns true if the signature in the given params is correct' do
      params = {'a' => '1', 'b' => '2', 'timestamp' => '1461605396', 'sig' => '6af838ef94998832dbfc29020b564830'}

      client = Nexmo::Client.new(key: @api_key, secret: @api_secret, signature_secret: 'secret')

      client.check_signature(params).must_equal(true)
    end

    it 'raises an authentication error exception if the signature secret was not provided' do
      client = Nexmo::Client.new(key: @api_key, secret: @api_secret)

      exception = proc { client.check_signature({}) }.must_raise(Nexmo::AuthenticationError)

      exception.message.must_include('No signature_secret provided.')
    end
  end

  it 'raises an authentication error exception if the api key was not provided' do
    client = Nexmo::Client.new(secret: @api_secret)

    exception = proc { client.get_balance }.must_raise(Nexmo::AuthenticationError)

    exception.message.must_include('No API key provided.')
  end

  it 'raises an authentication error exception if the api secret was not provided' do
    client = Nexmo::Client.new(key: @api_key)

    exception = proc { client.get_balance }.must_raise(Nexmo::AuthenticationError)

    exception.message.must_include('No API secret provided.')
  end

  it 'raises an authentication error exception if the application id was not provided' do
    client = Nexmo::Client.new(private_key: @private_key)

    exception = proc { client.get_calls }.must_raise(Nexmo::AuthenticationError)

    exception.message.must_include('No application_id provided.')
  end

  it 'raises an authentication error exception if the private key was not provided' do
    client = Nexmo::Client.new(application_id: @application_id)

    exception = proc { client.get_calls }.must_raise(Nexmo::AuthenticationError)

    exception.message.must_include('No private_key provided.')
  end

  it 'raises an authentication error exception if the response code is 401' do
    stub_request(:get, /#{@base_url}/).to_return(status: 401)

    proc { @client.get_balance }.must_raise(Nexmo::AuthenticationError)
  end

  it 'raises a client error exception if the response code is 4xx' do
    stub_request(:get, /#{@base_url}/).to_return(status: 400)

    proc { @client.get_balance }.must_raise(Nexmo::ClientError)
  end

  it 'raises a server error exception if the response code is 5xx' do
    stub_request(:get, /#{@base_url}/).to_return(status: 500)

    proc { @client.get_balance }.must_raise(Nexmo::ServerError)
  end

  it 'provides an accessor to set the authorization token' do
    auth_token = 'auth_token_xxx'

    headers = {'Authorization' => "Bearer #{auth_token}"}

    @request = stub_request(:get, "#@api_base_url/v1/calls").with(headers: headers).to_return(@response_body)

    @client.auth_token = auth_token

    @client.get_calls
  end

  it 'includes a user-agent header with the library version number and ruby version number' do
    headers = {'User-Agent' => "nexmo-ruby/#{Nexmo::VERSION} ruby/#{RUBY_VERSION}"}

    stub_request(:get, /#{@base_url}/).with(headers: headers).to_return(@response_body)

    @client.get_balance
  end

  it 'provides options for application name and version to be included in the user-agent header' do
    app_name, app_version = 'ExampleApp', 'X.Y.Z'

    headers = {'User-Agent' => "nexmo-ruby/#{Nexmo::VERSION} ruby/#{RUBY_VERSION} #{app_name}/#{app_version}"}

    stub_request(:get, /#{@base_url}/).with(headers: headers).to_return(@response_body)

    @client = Nexmo::Client.new(key: @api_key, secret: @api_secret, app_name: app_name, app_version: app_version)

    @client.get_balance
  end

  it 'provides an option for specifying a different hostname to connect to' do
    expect_get "https://rest-sandbox.nexmo.com/account/get-balance?api_key=#@api_key&api_secret=#@api_secret"

    @client = Nexmo::Client.new(key: @api_key, secret: @api_secret, host: 'rest-sandbox.nexmo.com')

    @client.get_balance
  end

  it 'provides an option for specifying a different api hostname to connect to' do
    expect_get "https://debug.example.com/ni/basic/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

    @client = Nexmo::Client.new(key: @api_key, secret: @api_secret, api_host: 'debug.example.com')

    @client.get_basic_number_insight(number: '447525856424')
  end

  private

  def expect(method_symbol, url, body = nil)
    headers = {'Authorization' => /\ABearer (.+)\.(.+)\.(.+)\z/}

    @request = stub_request(method_symbol, url)

    if method_symbol == :delete
      @request.with(headers: headers).to_return(status: 204)
    elsif body.nil?
      @request.with(headers: headers).to_return(@response_body)
    else
      headers['Content-Type'] = 'application/json'

      @request.with(headers: headers, body: body).to_return(@response_body)
    end
  end

  def expect_get(url)
    @request = stub_request(:get, url).to_return(@response_body)
  end

  def expect_post(url, data)
    body = WebMock::Util::QueryMapper.query_to_values(data)

    headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

    @request = stub_request(:post, url).with(body: body, headers: headers).to_return(@response_body)
  end

  def expect_put(url, data)
    body = WebMock::Util::QueryMapper.query_to_values(data)

    headers = {'Content-Type' => 'application/json'}

    @request = stub_request(:put, url).with(body: body, headers: headers).to_return(@response_body)
  end

  def expect_delete(url)
    @request = stub_request(:delete, url).to_return(status: 204)
  end

  after do
    assert_requested(@request) if defined?(@request)
  end
end
