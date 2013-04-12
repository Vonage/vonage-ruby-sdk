require 'net/http'
require 'net/https' if RUBY_VERSION == '1.8.7'
require 'json'
require 'cgi'

module Nexmo
  class Client
    def initialize(key = ENV['NEXMO_API_KEY'], secret = ENV['NEXMO_API_SECRET'], options = {}, &block)
      @key, @secret, @block = key, secret, block

      if options.has_key?(:json)
        Kernel.warn '[nexmo] :json option is deprecated'

        @json = options[:json]
      else
        @json = JSON
      end

      @http = Net::HTTP.new('rest.nexmo.com', Net::HTTP.https_default_port)

      @http.use_ssl = true
    end

    attr_accessor :key, :secret, :http, :oauth_access_token

    def send_message(params)
      post('/sms/json', params.merge(:type => 'unicode'))
    end

    def send_message!(params)
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

      decode(http_response)
    end

    def post(path, params)
      http_response = if oauth_access_token
        oauth_access_token.post(path, @json.dump(params), {'Content-Type' => 'application/json'})
      else
        @http.post(path, @json.dump(params.merge(:api_key => @key, :api_secret => @secret)), {'Content-Type' => 'application/json'})
      end

      decode(http_response)
    end

    def decode(http_response)
      response = Response.new(http_response, :json => @json)

      @block ? @block.call(response) : response
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
    attr_writer :object

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
      @object ||= @json.parse(body)
    end
  end

  class Error < StandardError
  end
end
