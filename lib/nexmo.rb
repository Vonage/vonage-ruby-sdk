require 'net/http'
require 'json'
require 'cgi'

module Nexmo
  class Error < StandardError; end

  class AuthenticationError < Error; end

  class Client
    attr_accessor :key, :secret, :http

    def initialize(options = {})
      @key = options.fetch(:key) { ENV.fetch('NEXMO_API_KEY') }

      @secret = options.fetch(:secret) { ENV.fetch('NEXMO_API_SECRET') }

      @host = options.fetch(:host) { 'rest.nexmo.com' }

      @http = Net::HTTP.new(@host, Net::HTTP.https_default_port)

      @http.use_ssl = true
    end

    def send_message(params)
      response = post('/sms/json', params)

      item = response['messages'].first

      status = item['status'].to_i

      if status == 0
        item['message-id']
      else
        raise Error, "#{item['error-text']} (status=#{status})"
      end
    end

    def get_balance
      get('/account/get-balance')
    end

    def get_country_pricing(country_code)
      get('/account/get-pricing/outbound', {:country => country_code})
    end

    def get_prefix_pricing(prefix)
      get('/account/get-prefix-pricing/outbound', {:prefix => prefix})
    end

    def get_account_numbers(params)
      get('/account/numbers', params)
    end

    def number_search(country_code, params = {})
      get('/number/search', {:country => country_code}.merge(params))
    end

    def buy_number(params)
      post('/number/buy', params)
    end

    def cancel_number(params)
      post('/number/cancel', params)
    end

    def update_number(params)
      post('/number/update', params)
    end

    def get_message(id)
      get('/search/message', {:id => id})
    end

    def get_message_rejections(params)
      get('/search/rejections', params)
    end

    def search_messages(params)
      get('/search/messages', Hash === params ? params : {:ids => Array(params)})
    end

    def send_ussd_push_message(params)
      post('/ussd/json', params)
    end

    def send_ussd_prompt_message(params)
      post('/ussd-prompt/json', params)
    end

    def send_2fa_message(params)
      post('/sc/us/2fa/json', params)
    end

    def send_event_alert_message(params)
      post('/sc/us/alert/json', params)
    end

    def send_marketing_message(params)
      post('/sc/us/marketing/json', params)
    end

    def initiate_call(params)
      post('/call/json', params)
    end

    def initiate_tts_call(params)
      post('/tts/json', params)
    end

    def initiate_tts_prompt_call(params)
      post('/tts-prompt/json', params)
    end

    private

    def get(path, params = {})
      parse @http.get(request_uri(path, params.merge(:api_key => @key, :api_secret => @secret)))
    end

    def post(path, params)
      body = URI.encode_www_form(params.merge(:api_key => @key, :api_secret => @secret))

      parse @http.post(path, body, {'Content-Type' => 'application/x-www-form-urlencoded'})
    end

    def parse(http_response)
      case http_response
      when Net::HTTPSuccess
        if http_response['Content-Type'].split(';').first == 'application/json'
          JSON.parse(http_response.body)
        else
          http_response.body
        end
      when Net::HTTPUnauthorized
        raise AuthenticationError
      else
        raise Error, "Unexpected HTTP response (code=#{http_response.code})"
      end
    end

    def request_uri(path, hash = {})
      if hash.empty?
        path
      else
        query_params = hash.map do |key, values|
          Array(values).map { |value| "#{escape(key)}=#{escape(value)}" }
        end

        path + '?' + query_params.flatten.join('&')
      end
    end

    def escape(component)
      CGI.escape(component.to_s)
    end
  end
end
