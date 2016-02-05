require 'net/http'
require 'json'
require 'cgi'

module Nexmo
  class Error < StandardError; end

  class AuthenticationError < Error; end

  class Client
    attr_accessor :key, :secret

    def initialize(options = {})
      @key = options.fetch(:key) { ENV.fetch('NEXMO_API_KEY') }

      @secret = options.fetch(:secret) { ENV.fetch('NEXMO_API_SECRET') }

      @host = options.fetch(:host) { 'rest.nexmo.com' }

      @autodetect_type = options.fetch(:autodetect_type) { false }
    end

    def send_message(params)
      if @autodetect_type && !params[:type]
        params[:type] = unicode?(params[:text]) ? 'unicode' : 'text'
      end

      response = post('/sms/json', params)

      item = response['messages'].first

      status = item['status'].to_i

      raise Error, "#{item['error-text']} (status=#{status})" unless status.zero?

      return item
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

    def get_available_numbers(country_code, params = {})
      get('/number/search', {:country => country_code}.merge(params))
    end

    def number_search(country_code, params = {})
      Kernel.warn '[nexmo] #number_search is deprecated and will be removed, please use #get_available_numbers instead'

      get_available_numbers(country_code, params)
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
      post('https://api.nexmo.com/tts/json', params)
    end

    def initiate_tts_prompt_call(params)
      post('https://api.nexmo.com/tts-prompt/json', params)
    end

    def send_verification_request(params)
      post('https://api.nexmo.com/verify/json', params)
    end

    def check_verification_request(params)
      post('https://api.nexmo.com/verify/check/json', params)
    end

    def get_verification_request(id)
      get('https://api.nexmo.com/verify/search/json', :request_id => id)
    end

    def control_verification_request(params)
      post('https://api.nexmo.com/verify/control/json', params)
    end

    def request_number_insight(params)
      post('/ni/json', params)
    end

    private

    def get(path, params = {})
      uri = URI.join("https://#{@host}", path)
      uri.query = query_string(params.merge(:api_key => @key, :api_secret => @secret))

      get_request = Net::HTTP::Get.new(uri.request_uri)

      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true

      parse http.request(get_request)
    end

    def post(path, params)
      uri = URI.join("https://#{@host}", path)

      content_type = 'application/x-www-form-urlencoded'
      if params[:text]
        content_type += '; charset=' + params[:text].encoding.to_s.downcase
      end

      post_request = Net::HTTP::Post.new(uri.request_uri)
      post_request.form_data = params.merge(:api_key => @key, :api_secret => @secret)
      post_request['Content-Type'] = content_type

      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true

      parse http.request(post_request)
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

    def query_string(params)
      params.flat_map { |k, vs| Array(vs).map { |v| "#{escape(k)}=#{escape(v)}" } }.join('&')
    end

    def escape(component)
      CGI.escape(component.to_s)
    end

    def unicode?(string)
      string.chars.any? { |c| c.bytes.count != 1 }
    end
  end
end
