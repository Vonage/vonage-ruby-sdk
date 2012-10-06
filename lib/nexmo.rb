require 'net/http'
require 'net/https'
require 'json'
require 'uri'

module Nexmo
  class Client
    def initialize(key, secret)
      @key, @secret = key, secret

      @headers = {'Content-Type' => 'application/x-www-form-urlencoded'}

      @http = Net::HTTP.new('rest.nexmo.com', 443)

      @http.use_ssl = true
    end

    attr_accessor :key, :secret, :http, :headers

    def send_message(data)
      response = @http.post('/sms/json', encode(data), headers)

      if ok?(response) && json?(response)
        object = JSON.parse(response.body)['messages'].first

        status = object['status'].to_i

        if status == 0
          Success.new(object['message-id'])
        else
          Failure.new(Error.new("#{object['error-text']} (status=#{status})"), response, status)
        end
      else
        Failure.new(Error.new("Unexpected HTTP response (code=#{response.code})"), response)
      end
    end

    def get_balance
      Response.new(@http.get("/account/get-balance/#{key}/#{secret}"))
    end

    def get_country_pricing(country_code)
      Response.new(@http.get("/account/get-pricing/outbound/#{key}/#{secret}/#{country_code}"))
    end

    private

    def ok?(response)
      response.code.to_i == 200
    end

    def json?(response)
      response['Content-Type'].split(?;).first == 'application/json'
    end

    def encode(data)
      URI.encode_www_form data.merge(:username => @key, :password => @secret)
    end
  end

  class Response
    def initialize(http_response)
      @http_response = http_response
    end

    def method_missing(name, *args, &block)
      @http_response.send(name, *args, &block)
    end

    def ok?
      code.to_i == 200
    end

    def json?
      self['Content-Type'].split(?;).first == 'application/json'
    end

    def object
      JSON.parse(body, object_class: Object)
    end
  end

  class Object
    def initialize(attributes = {})
      @attributes = attributes.to_hash
    end

    def [](name)
      @attributes[name]
    end

    def []=(name, value)
      @attributes[name.to_s.tr(?-, ?_).to_sym] = value
    end

    def to_hash
      @attributes
    end

    def respond_to_missing?(name, include_private = false)
      @attributes.has_key?(name)
    end

    def method_missing(name, *args, &block)
      if @attributes.has_key?(name) && args.empty? && block.nil?
        @attributes[name]
      else
        super name, *args, &block
      end
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
