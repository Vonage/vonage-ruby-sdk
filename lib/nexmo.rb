require 'nexmo/version'
require 'net/http'
require 'json'
require 'cgi'

module Nexmo
  class Error < StandardError; end

  class ClientError < Error; end

  class ServerError < Error; end

  class AuthenticationError < ClientError; end

  class Client
    attr_accessor :key, :secret

    def initialize(options = {})
      @key = options.fetch(:key) { ENV.fetch('NEXMO_API_KEY') }

      @secret = options.fetch(:secret) { ENV.fetch('NEXMO_API_SECRET') }

      @host = options.fetch(:host) { 'rest.nexmo.com' }

      @api_host = options.fetch(:api_host) { 'api.nexmo.com' }
    end

    def send_message(params)
      post(@host, '/sms/json', params)
    end

    def get_balance
      get(@host, '/account/get-balance')
    end

    def get_country_pricing(country_code)
      get(@host, '/account/get-pricing/outbound', country: country_code)
    end

    def get_prefix_pricing(prefix)
      get(@host, '/account/get-prefix-pricing/outbound', prefix: prefix)
    end

    def get_sms_pricing(number)
      get(@host, '/account/get-phone-pricing/outbound/sms', phone: number)
    end

    def get_voice_pricing(number)
      get(@host, '/account/get-phone-pricing/outbound/voice', phone: number)
    end

    def update_settings(params)
      post(@host, '/account/settings', params)
    end

    def topup(params)
      post(@host, '/account/top-up', params)
    end

    def get_account_numbers(params)
      get(@host, '/account/numbers', params)
    end

    def get_available_numbers(country_code, params = {})
      get(@host, '/number/search', {country: country_code}.merge(params))
    end

    def buy_number(params)
      post(@host, '/number/buy', params)
    end

    def cancel_number(params)
      post(@host, '/number/cancel', params)
    end

    def update_number(params)
      post(@host, '/number/update', params)
    end

    def get_message(id)
      get(@host, '/search/message', id: id)
    end

    def get_message_rejections(params)
      get(@host, '/search/rejections', params)
    end

    def search_messages(params)
      get(@host, '/search/messages', Hash === params ? params : {ids: Array(params)})
    end

    def send_ussd_push_message(params)
      post(@host, '/ussd/json', params)
    end

    def send_ussd_prompt_message(params)
      post(@host, '/ussd-prompt/json', params)
    end

    def send_2fa_message(params)
      post(@host, '/sc/us/2fa/json', params)
    end

    def send_event_alert_message(params)
      post(@host, '/sc/us/alert/json', params)
    end

    def send_marketing_message(params)
      post(@host, '/sc/us/marketing/json', params)
    end

    def get_event_alert_numbers
      get(@host, '/sc/us/alert/opt-in/query/json')
    end

    def resubscribe_event_alert_number(params)
      post(@host, '/sc/us/alert/opt-in/manage/json', params)
    end

    def initiate_call(params)
      post(@host, '/call/json', params)
    end

    def initiate_tts_call(params)
      post(@api_host, '/tts/json', params)
    end

    def initiate_tts_prompt_call(params)
      post(@api_host, '/tts-prompt/json', params)
    end

    def start_verification(params)
      post(@api_host, '/verify/json', params)
    end

    def send_verification_request(params)
      post(@api_host, '/verify/json', params)
    end

    def check_verification(request_id, params)
      post(@api_host, '/verify/check/json', params.merge(request_id: request_id))
    end

    def check_verification_request(params)
      post(@api_host, '/verify/check/json', params)
    end

    def get_verification(request_id)
      get(@api_host, '/verify/search/json', request_id: request_id)
    end

    def get_verification_request(id)
      get(@api_host, '/verify/search/json', request_id: id)
    end

    def cancel_verification(request_id)
      post(@api_host, '/verify/control/json', request_id: request_id, cmd: 'cancel')
    end

    def trigger_next_verification_event(request_id)
      post(@api_host, '/verify/control/json', request_id: request_id, cmd: 'trigger_next_event')
    end

    def control_verification_request(params)
      post(@api_host, '/verify/control/json', params)
    end

    def get_basic_number_insight(params)
      get(@api_host, '/number/format/json', params)
    end

    def get_number_insight(params)
      get(@api_host, '/number/lookup/json', params)
    end

    def request_number_insight(params)
      post(@host, '/ni/json', params)
    end

    private

    USER_AGENT = "ruby-nexmo/#{VERSION}/#{RUBY_VERSION}"

    def get(host, request_uri, params = {})
      uri = URI('https://' + host + request_uri)
      uri.query = query_string(params.merge(api_key: @key, api_secret: @secret))

      message = Net::HTTP::Get.new(uri.request_uri)
      message['User-Agent'] = USER_AGENT

      parse(request(uri, message), host)
    end

    def post(host, request_uri, params)
      uri = URI('https://' + host + request_uri)

      message = Net::HTTP::Post.new(uri.request_uri)
      message.form_data = params.merge(api_key: @key, api_secret: @secret)
      message['User-Agent'] = USER_AGENT

      parse(request(uri, message), host)
    end

    def request(uri, message)
      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true
      http.request(message)
    end

    def parse(http_response, host)
      case http_response
      when Net::HTTPSuccess
        if http_response['Content-Type'].split(';').first == 'application/json'
          JSON.parse(http_response.body)
        else
          http_response.body
        end
      when Net::HTTPUnauthorized
        raise AuthenticationError, "#{http_response.code} response from #{host}"
      when Net::HTTPClientError
        raise ClientError, "#{http_response.code} response from #{host}"
      when Net::HTTPServerError
        raise ServerError, "#{http_response.code} response from #{host}"
      else
        raise Error, "#{http_response.code} response from #{host}"
      end
    end

    def query_string(params)
      params.flat_map { |k, vs| Array(vs).map { |v| "#{escape(k)}=#{escape(v)}" } }.join('&')
    end

    def escape(component)
      CGI.escape(component.to_s)
    end
  end
end
