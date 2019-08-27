# frozen_string_literal: true
require 'net/http'
require 'json'

module Nexmo
  class Namespace
    def initialize(config)
      @config = config

      @logger = config.logger

      @host = self.class.host

      @http = Net::HTTP.new(@host, Net::HTTP.https_default_port, p_addr = nil)
      @http.use_ssl = true

      @config.http.set(@http) unless @config.http.nil?
    end

    def self.host
      @host ||= 'api.nexmo.com'
    end

    def self.host=(host)
      @host = host
    end

    def self.authentication
      @authentication ||= KeySecretParams
    end

    def self.authentication=(authentication)
      @authentication = authentication
    end

    def self.request_body
      @request_body ||= FormData
    end

    def self.request_body=(request_body)
      @request_body = request_body
    end

    def self.request_headers
      @request_headers ||= {}
    end

    private

    Get = Net::HTTP::Get
    Put = Net::HTTP::Put
    Post = Net::HTTP::Post
    Delete = Net::HTTP::Delete

    def request(path, params: nil, type: Get, &block)
      uri = URI('https://' + @host + path)

      params ||= {}

      authentication = self.class.authentication.new(@config)
      authentication.update(params)

      unless type::REQUEST_HAS_BODY || params.empty?
        uri.query = Params.encode(params)
      end

      authentication.update(uri)

      message = type.new(uri)

      message['User-Agent'] = UserAgent.string(@config.app_name, @config.app_version)

      self.class.request_headers.each do |key, value|
        message[key] = value
      end

      authentication.update(message)

      self.class.request_body.update(message, params) if type::REQUEST_HAS_BODY

      @logger.log_request_info(message)

      response = @http.request(message, &block)

      @logger.log_response_info(response, @host)

      return if block

      @logger.debug(response.body) if response.body

      parse(response)
    end

    def parse(response)
      case response
      when Net::HTTPNoContent
        :no_content
      when Net::HTTPSuccess
        if response['Content-Type'].split(';').first == 'application/json'
          ::JSON.parse(response.body, object_class: Nexmo::Entity)
        else
          response
        end
      else
        raise Errors.parse(response)
      end
    end
  end

  private_constant :Namespace
end
