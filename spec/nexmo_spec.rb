require 'minitest/autorun'
require 'webmock/minitest'
require 'nexmo'

describe 'Nexmo::Client' do
  before do
    @api_key = 'api_key_xxx'

    @api_secret = 'api_secret_xxx'

    @base_url = 'https://rest.nexmo.com'

    @api_base_url = 'https://api.nexmo.com'

    @response_body = {body: '{"key":"value"}', headers: {'Content-Type' => 'application/json;charset=utf-8'}}

    @response_object = {'key' => 'value'}

    @example_message_hash = {from: 'ruby', to: 'number', text: 'Hey!'}

    @client = Nexmo::Client.new(key: @api_key, secret: @api_secret)
  end

  describe 'send_message method' do
    it 'posts to the sms resource and returns the response object' do
      expect_post "#@base_url/sms/json", "from=ruby&to=number&text=Hey!&api_key=#@api_key&api_secret=#@api_secret"

      @client.send_message(@example_message_hash).must_equal(@response_object)
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

  describe 'send_ussd_push_message method' do
    it 'posts to the ussd resource and returns the response object' do
      expect_post "#@base_url/ussd/json", "api_key=#@api_key&api_secret=#@api_secret&from=MyCompany20&to=447525856424&text=Hello"

      @client.send_ussd_push_message(from: 'MyCompany20', to: '447525856424', text: 'Hello')
    end
  end

  describe 'send_ussd_prompt_message method' do
    it 'posts to the ussd prompt resource and returns the response object' do
      expect_post "#@base_url/ussd-prompt/json", "api_key=#@api_key&api_secret=#@api_secret&from=virtual-number&to=447525856424&text=Hello"

      @client.send_ussd_prompt_message(from: 'virtual-number', to: '447525856424', text: 'Hello')
    end
  end

  describe 'send_2fa_message method' do
    it 'posts to the short code two factor authentication resource and returns the response object' do
      expect_post "#@base_url/sc/us/2fa/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&pin=1234"

      @client.send_2fa_message(to: '16365553226', pin: 1234)
    end
  end

  describe 'send_event_alert_message method' do
    it 'posts to the short code alert resource and returns the response object' do
      expect_post "#@base_url/sc/us/alert/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&server=host&link=http://example.com/"

      @client.send_event_alert_message(to: '16365553226', server: 'host', link: 'http://example.com/')
    end
  end

  describe 'send_marketing_message method' do
    it 'posts to the short code marketing resource and returns the response object' do
      expect_post "#@base_url/sc/us/marketing/json", "api_key=#@api_key&api_secret=#@api_secret&from=666&to=16365553226&keyword=NEXMO&text=Hello"

      @client.send_marketing_message(from: '666', to: '16365553226', keyword: 'NEXMO', text: 'Hello')
    end
  end

  describe 'get_event_alert_numbers method' do
    it 'fetches the short code alert opt-in query resource and returns the response object' do
      expect_get "#@base_url/sc/us/alert/opt-in/query/json?api_key=#@api_key&api_secret=#@api_secret"

      @client.get_event_alert_numbers
    end
  end

  describe 'resubscribe_event_alert_number method' do
    it 'posts to the short code alert opt-in manage resource and returns the response object' do
      expect_post "#@base_url/sc/us/alert/opt-in/manage/json", "api_key=#@api_key&api_secret=#@api_secret&msisdn=441632960960"

      @client.resubscribe_event_alert_number(msisdn: '441632960960')
    end
  end

  describe 'initiate_call method' do
    it 'posts to the call resource and returns the response object' do
      expect_post "#@base_url/call/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&answer_url=http://example.com/answer"

      @client.initiate_call(to: '16365553226', answer_url: 'http://example.com/answer')
    end
  end

  describe 'initiate_tts_call method' do
    it 'posts to the tts resource and returns the response object' do
      expect_post "#@api_base_url/tts/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&text=Hello"

      @client.initiate_tts_call(to: '16365553226', text: 'Hello')
    end
  end

  describe 'initiate_tts_prompt_call method' do
    it 'posts to the tts prompt resource and returns the response object' do
      expect_post "#@api_base_url/tts-prompt/json", "api_key=#@api_key&api_secret=#@api_secret&to=16365553226&text=Hello&max_digits=4&bye_text=Goodbye"

      @client.initiate_tts_prompt_call(to: '16365553226', text: 'Hello', max_digits: 4, bye_text: 'Goodbye')
    end
  end

  describe 'start_verification method' do
    it 'posts to the verify json resource and returns the response object' do
      expect_post "#@api_base_url/verify/json", "api_key=#@api_key&api_secret=#@api_secret&number=447525856424&brand=MyApp"

      @client.start_verification(number: '447525856424', brand: 'MyApp')
    end
  end

  describe 'send_verification_request method' do
    it 'posts to the verify resource and returns the response object' do
      expect_post "#@api_base_url/verify/json", "api_key=#@api_key&api_secret=#@api_secret&number=447525856424&brand=MyApp"

      @client.send_verification_request(number: '447525856424', brand: 'MyApp')
    end
  end

  describe 'check_verification method' do
    it 'posts to the verify check resource and returns the response object' do
      expect_post "#@api_base_url/verify/check/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&code=123445"

      @client.check_verification('8g88g88eg8g8gg9g90', code: '123445')
    end
  end

  describe 'check_verification_request method' do
    it 'posts to the verify check resource and returns the response object' do
      expect_post "#@api_base_url/verify/check/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&code=123445"

      @client.check_verification_request(request_id: '8g88g88eg8g8gg9g90', code: '123445')
    end
  end

  describe 'get_verification method' do
    it 'fetches the verify search resource with the given request id and returns the response object' do
      expect_get "#@api_base_url/verify/search/json?api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90"

      @client.get_verification('8g88g88eg8g8gg9g90')
    end
  end

  describe 'get_verification_request method' do
    it 'fetches the verify search resource with the given request id and returns the response object' do
      expect_get "#@api_base_url/verify/search/json?api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90"

      @client.get_verification_request('8g88g88eg8g8gg9g90')
    end
  end

  describe 'cancel_verification method' do
    it 'posts to the verify control resource and returns the response object' do
      expect_post "#@api_base_url/verify/control/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&cmd=cancel"

      @client.cancel_verification('8g88g88eg8g8gg9g90')
    end
  end

  describe 'trigger_next_verification_event method' do
    it 'posts to the verify control resource and returns the response object' do
      expect_post "#@api_base_url/verify/control/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&cmd=trigger_next_event"

      @client.trigger_next_verification_event('8g88g88eg8g8gg9g90')
    end
  end

  describe 'control_verification_request method' do
    it 'posts to the verify control resource and returns the response object' do
      expect_post "#@api_base_url/verify/control/json", "api_key=#@api_key&api_secret=#@api_secret&request_id=8g88g88eg8g8gg9g90&cmd=cancel"

      @client.control_verification_request(request_id: '8g88g88eg8g8gg9g90', cmd: 'cancel')
    end
  end

  describe 'get_basic_number_insight method' do
    it 'fetches the number format resource and returns the response object' do
      expect_get "#@api_base_url/number/format/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

      @client.get_basic_number_insight(number: '447525856424')
    end
  end

  describe 'get_number_insight method' do
    it 'fetches the number lookup resource and returns the response object' do
      expect_get "#@api_base_url/number/lookup/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

      @client.get_number_insight(number: '447525856424')
    end
  end

  describe 'request_number_insight method' do
    it 'posts to the number insight resource and returns the response object' do
      expect_post "#@base_url/ni/json", "api_key=#@api_key&api_secret=#@api_secret&number=447525856424&callback=https://example.com"

      @client.request_number_insight(number: '447525856424', callback: 'https://example.com')
    end
  end

  it 'includes a user-agent header with the library version number and ruby version number' do
    headers = {'User-Agent' => "ruby-nexmo/#{Nexmo::VERSION}/#{RUBY_VERSION}"}

    stub_request(:post, "#@base_url/sms/json").with(headers: headers).to_return(@response_body)

    @client.send_message(@example_message_hash)
  end

  it 'raises an authentication error exception if the response code is 401' do
    stub_request(:post, "#@base_url/sms/json").to_return(status: 401)

    proc { @client.send_message(@example_message_hash) }.must_raise(Nexmo::AuthenticationError)
  end

  it 'raises a client error exception if the response code is 4xx' do
    stub_request(:post, "#@base_url/sms/json").to_return(status: 400)

    proc { @client.send_message(@example_message_hash) }.must_raise(Nexmo::ClientError)
  end

  it 'raises a server error exception if the response code is 5xx' do
    stub_request(:post, "#@base_url/sms/json").to_return(status: 500)

    proc { @client.send_message(@example_message_hash) }.must_raise(Nexmo::ServerError)
  end

  it 'provides an option for specifying a different hostname to connect to' do
    expect_get "https://rest-sandbox.nexmo.com/account/get-balance?api_key=#@api_key&api_secret=#@api_secret"

    @client = Nexmo::Client.new(key: @api_key, secret: @api_secret, host: 'rest-sandbox.nexmo.com')

    @client.get_balance
  end

  it 'provides an option for specifying a different api hostname to connect to' do
    expect_get "https://debug.example.com/number/format/json?api_key=#@api_key&api_secret=#@api_secret&number=447525856424"

    @client = Nexmo::Client.new(key: @api_key, secret: @api_secret, api_host: 'debug.example.com')

    @client.get_basic_number_insight(number: '447525856424')
  end

  private

  def expect_get(url)
    @request = stub_request(:get, url).to_return(@response_body)
  end

  def expect_post(url, data)
    body = WebMock::Util::QueryMapper.query_to_values(data)

    headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

    @request = stub_request(:post, url).with(body: body, headers: headers).to_return(@response_body)
  end

  after do
    assert_requested(@request) if defined?(@request)
  end
end
