require 'simplecov'

SimpleCov.start do
  add_filter 'test/nexmo'
end

require 'minitest/autorun'
require 'webmock/minitest'
require 'nexmo'

module Nexmo
  class Test < Minitest::Test
    def setup
      super

      @request_stubs = []
    end

    def stub_request(*args)
      super.tap do |stub|
        @request_stubs << stub
      end
    end

    def teardown
      @request_stubs.each do |stub|
        assert_requested(stub)
      end

      super
    end

    def api_key
      'nexmo-api-key'
    end

    def api_secret
      'nexmo-api-secret'
    end

    def api_key_and_secret
      {api_key: api_key, api_secret: api_secret}
    end

    def signature_secret
      'nexmo-signature-secret'
    end

    def application_id
      'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def private_key
      File.read(File.expand_path(File.join(File.dirname(__FILE__), '..', 'private_key.txt')))
    end

    def config
      @config ||= Nexmo::Config.new.merge({
        api_key: api_key,
        api_secret: api_secret,
        signature_secret: signature_secret,
        application_id: application_id,
        private_key: private_key
      })
    end

    def headers
      {'Content-Type' => 'application/x-www-form-urlencoded'}
    end

    def bearer_token
      /\ABearer (.+)\.(.+)\.(.+)\z/
    end

    def authorization
      bearer_token
    end

    def basic_authorization
      'Basic bmV4bW8tYXBpLWtleTpuZXhtby1hcGktc2VjcmV0'
    end

    def request(body: nil, query: nil, headers: {})
      headers['Authorization'] = authorization
      headers['Content-Type'] = 'application/json' if body

      {headers: headers, body: body, query: query}.reject { |k, v| v.nil? }
    end

    def response
      {body: '{"key":"value"}', headers: response_headers}
    end

    def response_headers
      {'Content-Type' => 'application/json;charset=utf-8'}
    end

    def msisdn
      '447700900000'
    end

    def conversation_id
      'CON-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def call_id
      'CALL-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    alias_method :call_uuid, :call_id
  end
end
