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
      @host = options[:host]
      @default_hosts = { rest: 'https://rest.nexmo.com', api: 'https://api.nexmo.com' }
    end

    def send_message(params)
      post(:rest, '/sms/json', params)
    end

    def get_balance
      get(:rest, '/account/get-balance')
    end

    def get_country_pricing(country_code)
      get(:rest, '/account/get-pricing/outbound', country: country_code)
    end

    def get_prefix_pricing(prefix)
      get(:rest, '/account/get-prefix-pricing/outbound', prefix: prefix)
    end

    def get_account_numbers(params)
      get(:rest, '/account/numbers', params)
    end

    def get_available_numbers(country_code, params = {})
      get(:rest, '/number/search', { country: country_code }.merge(params))
    end

    def buy_number(params)
      post(:rest, '/number/buy', params)
    end

    def cancel_number(params)
      post(:rest, '/number/cancel', params)
    end

    def update_number(params)
      post(:rest, '/number/update', params)
    end

    def get_message(id)
      get(:rest, '/search/message', id: id)
    end

    def get_message_rejections(params)
      get(:rest, '/search/rejections', params)
    end

    def search_messages(params)
      get(:rest, '/search/messages', Hash === params ? params : { ids: Array(params) })
    end

    def send_ussd_push_message(params)
      post(:rest, '/ussd/json', params)
    end

    def send_ussd_prompt_message(params)
      post(:rest, '/ussd-prompt/json', params)
    end

    def send_2fa_message(params)
      post(:rest, '/sc/us/2fa/json', params)
    end

    def send_event_alert_message(params)
      post(:rest, '/sc/us/alert/json', params)
    end

    def send_marketing_message(params)
      post(:rest, '/sc/us/marketing/json', params)
    end

    def initiate_call(params)
      post(:rest, '/call/json', params)
    end

    def initiate_tts_call(params)
      post(:api, '/tts/json', params)
    end

    def initiate_tts_prompt_call(params)
      post(:api, '/tts-prompt/json', params)
    end

    def send_verification_request(params)
      post(:api, '/verify/json', params)
    end

    def check_verification_request(params)
      post(:api, '/verify/check/json', params)
    end

    def get_verification_request(id)
      get(:api, '/verify/search/json', request_id: id)
    end

    def control_verification_request(params)
      post(:api, '/verify/control/json', params)
    end

    def get_basic_number_insight(params)
      get(:api, '/number/format/json', params)
    end

    def get_number_insight(params)
      get(:api, '/number/lookup/json', params)
    end

    def request_number_insight(params)
      post(:rest, '/ni/json', params)
    end

    private

    USER_AGENT = "ruby-nexmo/#{VERSION}/#{RUBY_VERSION}"

    def get(default_host_type, path, params = {})
      uri = build_uri(default_host_type, path)
      uri.query = query_string(params.merge(api_key: @key, api_secret: @secret))

      request = Net::HTTP::Get.new(uri.request_uri)
      request['User-Agent'] = USER_AGENT
      make_request(uri, request)
    end

    def post(default_host_type, path, params)
      uri = build_uri(default_host_type, path)

      request = Net::HTTP::Post.new(uri.request_uri)
      request.form_data = params.merge(api_key: @key, api_secret: @secret)
      request['User-Agent'] = USER_AGENT
      make_request(uri, request)
    end

    def make_request(uri, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.is_a?(URI::HTTPS)

      response = http.request(request)
      parse(response, uri.host)
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

    def build_uri(default_host_type, path)
      host = @host || @default_hosts[default_host_type]
      host = 'https://' + host unless host.start_with?('http')
      URI(host + path)
    end

    def query_string(params)
      params.flat_map { |k, vs| Array(vs).map { |v| "#{escape(k)}=#{escape(v)}" } }.join('&')
    end

    def escape(component)
      CGI.escape(component.to_s)
    end
  end
end
