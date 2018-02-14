require 'net/http'
require 'json'

module Nexmo
  class Namespace
    def initialize(client)
      @client = client
    end

    private

    Get = Net::HTTP::Get
    Put = Net::HTTP::Put
    Post = Net::HTTP::Post
    Delete = Net::HTTP::Delete

    def host
      'api.nexmo.com'
    end

    def authorization_header?
      false
    end

    def request(path, params: nil, type: Get, &block)
      uri = URI('https://' + host + path)

      unless authorization_header?
        params ||= {}
        params[:api_key] = @client.api_key
        params[:api_secret] = @client.api_secret
      end

      unless type::REQUEST_HAS_BODY || params.nil? || params.empty?
        uri.query = Params.encode(params)
      end

      message = type.new(uri.request_uri)

      if type::REQUEST_HAS_BODY
        message['Content-Type'] = 'application/json'
        message.body = JSON.generate(params)
      end

      message['Authorization'] = @client.authorization if authorization_header?
      message['User-Agent'] = @client.user_agent

      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true

      response = http.request(message)

      parse(response, &block)
    end

    def parse(response, &block)
      case response
      when Net::HTTPNoContent
        :no_content
      when Net::HTTPSuccess
        parse_success(response, &block)
      when Net::HTTPUnauthorized
        raise AuthenticationError, "#{response.code} response from #{host}"
      when Net::HTTPClientError
        raise ClientError, "#{response.code} response from #{host}"
      when Net::HTTPServerError
        raise ServerError, "#{response.code} response from #{host}"
      else
        raise Error, "#{response.code} response from #{host}"
      end
    end

    def parse_success(response)
      if response['Content-Type'].split(';').first == 'application/json'
        JSON.parse(response.body, object_class: Nexmo::Entity)
      elsif block_given?
        yield response
      else
        response.body
      end
    end
  end
end
