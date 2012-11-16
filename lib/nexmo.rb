require 'net/http'
require 'json'
require 'uri'
require 'cgi'

module Nexmo
  class Client
    def initialize(key, secret, options = {})
      @key, @secret = key, secret

      @json = options.fetch(:json) { JSON }

      @headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

      @http = Net::HTTP.new('rest.nexmo.com', 443)

      @http.use_ssl = true
    end

    attr_accessor :key, :secret, :http, :headers

    def send_message(data)
      response = @http.post('/sms/json', encode(data), headers)

      if response.code.to_i == 200 && response['Content-Type'].split(?;).first == 'application/json'
        object = @json.load(response.body)['messages'].first

        status = object['status'].to_i

        if status == 0
          Success.new(object['message-id'])
        else
          error = Error.new("#{object['error-text']} (status=#{status})")

          Failure.new(error, response, status)
        end
      else
        error = Error.new("Unexpected HTTP response (code=#{response.code})")

        Failure.new(error, response)
      end
    end

    def get_balance
      get("/account/get-balance/#{key}/#{secret}")
    end

    def get_country_pricing(country_code)
      get("/account/get-pricing/outbound/#{key}/#{secret}/#{country_code}")
    end

    def get_prefix_pricing(prefix)
      get("/account/get-prefix-pricing/outbound/#{key}/#{secret}/#{prefix}")
    end

    def get_account_numbers(params)
      get("/account/numbers/#{key}/#{secret}", params)
    end

    def number_search(country_code, params = {})
      get("/number/search/#{key}/#{secret}/#{country_code}", params)
    end

    def get_message(id)
      get("/search/message/#{key}/#{secret}/#{id}")
    end

    def get_message_rejections(params)
      get("/search/rejections/#{key}/#{secret}", params)
    end

    def search_messages(params)
      get("/search/messages/#{key}/#{secret}", Hash === params ? params : {ids: Array(params)})
    end

    private

    def get(path, params = {})
      Response.new(@http.get(request_uri(path, params)), json: @json)
    end

    def encode(data)
      URI.encode_www_form data.merge(:username => @key, :password => @secret)
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

  class Success < Struct.new(:message_id)
    def success?
      true
    end

    def failure?
      false
    end
  end

  class Failure < Struct.new(:error, :http, :status)
    def success?
      false
    end

    def failure?
      true
    end
  end

  class Error < StandardError
  end
end
