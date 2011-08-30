require 'net/http'
require 'net/https'
require 'json'
require 'cgi'

module Nexmo
  class Client
    def initialize(key, secret)
      @key, @secret = key, secret

      @http = Net::HTTP.new('rest.nexmo.com', 443)

      @http.use_ssl = true
    end

    attr_accessor :key, :secret, :http

    def send_message(data)
      response = post('/sms/json', data.merge(:username => @key, :password => @secret))

      object = JSON.parse(response.body)['messages'].first

      status = object['status'].to_i

      if status == 0
        Success.new(object['message-id'])
      else
        Failure.new(Error.new(object['error-text']))
      end
    end

    private

    def post(path, data)
      @http.post(path, urlencode(data), {'Content-Type' => 'application/x-www-form-urlencoded'})
    end

    def urlencode(data)
      data.map { |k, v| "#{urlescape(k)}=#{urlescape(v)}" }.join('&')
    end

    def urlescape(value)
      CGI.escape(value.to_s)
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

  class Failure < Struct.new(:error)
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
