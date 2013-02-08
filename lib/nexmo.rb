require 'net/http'
require 'net/https' if RUBY_VERSION == '1.8.7'
require 'json'
require 'cgi'

module Nexmo
  class Client
    def initialize(key = ENV['NEXMO_API_KEY'], secret = ENV['NEXMO_API_SECRET'], options = {})
      @key, @secret = key, secret

      @json = options.fetch(:json) { JSON }

      @http = Net::HTTP.new('rest.nexmo.com', Net::HTTP.https_default_port)

      @http.use_ssl = true
    end

    attr_accessor :key, :secret, :http, :oauth_access_token

    def send_message(params)
      post('/sms/json', params)
    end

    def send_message!(params, delay)
      sleep(delay)
      response = send_message(params)

      if response.ok? && response.json?
        item = response.object['messages'].first

        status = item['status'].to_i

        if status == 0
          item['message-id']
        else
          raise Error, "#{item['error-text']} (status=#{status})"
        end
      else
        raise Error, "Unexpected HTTP response (code=#{response.code})"
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

    def get_message(id)
      get('/search/message', {:id => id})
    end

    def get_message_rejections(params)
      get('/search/rejections', params)
    end

    def search_messages(params)
      get('/search/messages', Hash === params ? params : {:ids => Array(params)})
    end

    private

    def get(path, params = {})
      http_response = if oauth_access_token
        oauth_access_token.get(request_uri(path, params))
      else
        @http.get(request_uri(path, params.merge(:api_key => @key, :api_secret => @secret)))
      end

      Response.new(http_response, :json => @json)
    end

    def post(path, params)
      body = JSON.dump(params.merge(:api_key => @key, :api_secret => @secret))

      Response.new(@http.post(path, body, {'Content-Type' => 'application/json'}), :json => @json)
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

  class Response
    def initialize(http_response, options = {})
      @http_response = http_response

      @json = options.fetch(:json) { JSON }
    end

    def respond_to_missing?(name, include_private = false)
      @http_response.respond_to?(name)
    end

    def method_missing(name, *args, &block)
      @http_response.send(name, *args, &block)
    end

    def ok?
      code.to_i == 200
    end

    def json?
      self['Content-Type'].split(';').first == 'application/json'
    end

    def object
      @object ||= @json.load(body)
    end
  end

  class Error < StandardError
  end
end
