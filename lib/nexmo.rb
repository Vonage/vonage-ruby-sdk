require 'net/http'
require 'json'
require 'cgi'

module Nexmo

  @api_base_url = "https://api.nexmo.com"

  def self.endpoint_url
    @api_base_url
  end

  def self.endpoint_url=(api_base_url)
    @api_base_url = api_base_url
  end

  class Error < StandardError; end

  class AuthenticationError < Error; end

  class Client
    attr_accessor :key, :secret

    def initialize(options = {})
      @key = options.fetch(:key) { ENV.fetch('NEXMO_API_KEY') }
      @secret = options.fetch(:secret) { ENV.fetch('NEXMO_API_SECRET') }
    end

    def send_verification_request(params)
      post('/verify/json', params)
    end

    def check_verification_request(params)
      post('/verify/check/json', params)
    end

    def get_verification_request(id)
      get('/verify/search/json', :request_id => id)
    end

    def control_verification_request(params)
      post('/verify/control/json', params)
    end

    private

    def get(path, params = {})
      uri = URI.join(Nexmo.endpoint_url, path)
      uri.query = query_string(params.merge(api_key: @key, api_secret: @secret))

      get_request = Net::HTTP::Get.new(uri.request_uri)

      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true

      parse http.request(get_request)
    end

    def post(path, params)
      uri = URI.join(Nexmo.endpoint_url, path)

      post_request = Net::HTTP::Post.new(uri.request_uri)
      post_request.form_data = params.merge(api_key: @key, api_secret: @secret)

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
  end
end
