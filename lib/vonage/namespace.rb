# typed: true
# frozen_string_literal: true

require 'net/http'
require 'net/http/persistent'
require 'net/http/post/multipart'
require 'json'

module Vonage
  class Namespace
    def initialize(config)
      @config = config

      @host = set_host

      @http = Net::HTTP::Persistent.new

      @config.http.set(@http) unless @config.http.nil?
    end

    def self.host
      @host ||= :api_host
    end

    def self.host=(host)
      raise ArgumentError unless %i[rest_host video_host vonage_host].include?(host)
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

    # :nocov:

    Get = Net::HTTP::Get
    Put = Net::HTTP::Put
    Patch = Net::HTTP::Patch
    Post = Net::HTTP::Post
    Delete = Net::HTTP::Delete

    def build_request(path:, type: Get, params: {})
      authentication = self.class.authentication.new(@config)
      authentication.update(params)

      uri = URI("https://" + @host + path)
      unless type.const_get(:REQUEST_HAS_BODY) || params.empty?
        uri.query = Params.encode(params)
      end

      # Set BasicAuth if neeeded
      authentication.update(uri)

      # instantiate request
      request = type.new(uri)

      # set headers
      request["User-Agent"] = UserAgent.string(
        @config.app_name,
        @config.app_version
      )
      request["Accept"] = "application/json"
      self.class.request_headers.each { |key, value| request[key] = value }

      # Set BearerToken if needed
      authentication.update(request)

      # set body
      if type.const_get(:REQUEST_HAS_BODY)
        self.class.request_body.update(request, params)
      end

      request
    end

    def make_request!(request, &block)
      logger.log_request_info(request)

      uri = URI("https://" + @host + request.path)
      response = @http.request(uri, request, &block)

      logger.log_response_info(response, @host)

      return if block

      logger.debug(response.body) if response.body

      response
    end

    def request(path, params: nil, type: Get, response_class: Response, &block)
      auto_advance =
        (
          if !params.nil? && params.key?(:auto_advance)
            params[:auto_advance]
          else
            false
          end
        )

      params =
        params.tap { |params| params.delete(:auto_advance) } if !params.nil? &&
        params.key?(:auto_advance)

      request = build_request(path: path, params: params || {}, type: type)

      response = make_request!(request, &block)

      if auto_advance
        iterable_request(
          path,
          response: response,
          response_class: response_class,
          params: params,
          &block
        )
      else
        return if block

        parse(response, response_class)
      end
    end

    def multipart_post_request(path, filepath:, file_name:, mime_type:, params: {}, override_uri: nil, no_auth: false, response_class: Response, &block)
      authentication = self.class.authentication.new(@config) unless no_auth

      uri = override_uri ? URI(override_uri) : URI('https://' + @host + path)

      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port, p_addr = nil)
      http.use_ssl = true
      http.set_debug_output($stdout)

      response = File.open(filepath) do |file|
        request = Net::HTTP::Post::Multipart.new(
          uri,
          params.merge(file: Multipart::Post::UploadIO.new(file, mime_type, file_name))
        )

        request['User-Agent'] = UserAgent.string(@config.app_name, @config.app_version)

        # Set BearerToken if needed
        authentication.update(request) unless no_auth

        logger.log_request_info(request)

        http.request(request, &block)
      end

      logger.log_response_info(response, @host)

      return if block

      logger.debug(response.body) if response.body

      parse(response, response_class)
    end

    def iterable_request(path, response: nil, response_class: nil, params: {}, &block)
      json_response = ::JSON.parse(response.body)
      response = parse(response, response_class)
      remainder = remaining_count(json_response)

      while remainder > 0
        params = { page_size: json_response["page_size"] }

        if json_response["record_index"] && json_response["record_index"] == 0
          params[:record_index] = json_response["page_size"]
        elsif json_response["record_index"] &&
              json_response["record_index"] != 0
          params[:record_index] = (
            json_response["record_index"] + json_response["page_size"]
          )
        end

        if json_response["total_pages"]
          params[:page] = json_response["page"] + 1
        end

        request = build_request(path: path, type: Get, params: params)

        # Make request...
        paginated_response = make_request!(request)
        next_response = parse(paginated_response, response_class)
        json_response = ::JSON.parse(paginated_response.body)
        remainder = remaining_count(json_response)

        if response.respond_to?("_embedded")
          collection_name = collection_name(response["_embedded"])
          response["_embedded"][collection_name].push(
            *next_response["_embedded"][collection_name]
          )
        else
          response[collection_name(response)].push(
            *next_response[collection_name(next_response)]
          )
        end
      end

      response
    end

    def remaining_count(params)
      if params.key?("total_pages")
        params["total_pages"] - params["page"]
      elsif params.key?("count")
        params["count"] -
          (
            if params["record_index"] == 0
              params["page_size"]
            else
              (params["record_index"] + params["page_size"])
            end
          )
      else
        0
      end
    end

    def collection_name(params)
      @collection_name ||=
        case
        when params.respond_to?("calls")
          "calls"
        when params.respond_to?("users")
          "users"
        when params.respond_to?("legs")
          "legs"
        when params.respond_to?("data")
          "data"
        when params.respond_to?("conversations")
          "conversations"
        when params.respond_to?("applications")
          "applications"
        when params.respond_to?("records")
          "records"
        when params.respond_to?("reports")
          "reports"
        when params.respond_to?("networks")
          "networks"
        when params.respond_to?("countries")
          "countries"
        when params.respond_to?("media")
          "media"
        when params.respond_to?("numbers")
          "numbers"
        when params.respond_to?("events")
          "events"
        else
          params.entity.attributes.keys[0].to_s
        end
    end

    def parse(response, response_class)
      case response
      when Net::HTTPNoContent
        response_class.new(nil, response)
      when Net::HTTPSuccess
        if response['Content-Type'] && response['Content-Type'].split(';').first == 'application/json' && !response.body.empty?
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

    private

    def set_host
      case self.class.host
      when :rest_host
        @config.rest_host
      when :video_host
        @config.video_host
      when :vonage_host
        @config.vonage_host
      else
        @config.api_host
      end
    end
  end

  private_constant :Namespace
  # :nocov:
end
