# typed: ignore
# frozen_string_literal: true
require 'net/http'
require 'json'

module Vonage
  class Namespace
    def initialize(config)
      @config = config

      @host = self.class.host == :api_host ? @config.api_host : @config.rest_host

      @http = Net::HTTP.new(@host, Net::HTTP.https_default_port, p_addr = nil)
      @http.use_ssl = true

      @config.http.set(@http) unless @config.http.nil?
    end

    def self.host
      @host ||= :api_host
    end

    def self.host=(host)
      raise ArgumentError unless host == :rest_host

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

    protected

    Get = Net::HTTP::Get
    Put = Net::HTTP::Put
    Post = Net::HTTP::Post
    Delete = Net::HTTP::Delete

    def request(path, params: nil, type: Get, response_class: Response, &block)
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

      logger.log_request_info(message)

      response = @http.request(message, &block)

      logger.log_response_info(response, @host)

      return if block

      logger.debug(response.body) if response.body

      parse(response, response_class)
    end

    def parse(response, response_class)
      case response
      when Net::HTTPNoContent
        response_class.new(nil, response)
      when Net::HTTPSuccess
        if response['Content-Type'].split(';').first == 'application/json'
          entity = ::JSON.parse(response.body, object_class: Vonage::Entity)

          response_class.new(entity, response)
        else
          response_class.new(nil, response)
        end
      else
        raise Errors.parse(response)
      end
    end

    def logger
      @config.logger
    end
  end

  private_constant :Namespace
end
