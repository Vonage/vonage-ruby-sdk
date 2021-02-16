# typed: false
require 'simplecov'

SimpleCov.start do
  add_filter 'test/vonage'
end

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'minitest/autorun'
require 'webmock/minitest'
require 'timecop'
require 'vonage'

module Vonage
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
        assert_requested(stub, at_least_times: 1)
      end

      super
    end

    def api_key
      'vonage-api-key'
    end

    def api_secret
      'vonage-api-secret'
    end

    def api_key_and_secret
      {api_key: api_key, api_secret: api_secret}
    end

    def signature_secret
      'Vonage-signature-secret'
    end

    def application_id
      'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def private_key
      File.read(File.expand_path(File.join(File.dirname(__FILE__), '..', 'private_key.txt')))
    end

    def config
      @config ||= Vonage::Config.new.merge({
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
      'Basic dm9uYWdlLWFwaS1rZXk6dm9uYWdlLWFwaS1zZWNyZXQ='
    end

    def request(body: nil, query: nil, headers: {})
      headers['Authorization'] = authorization
      headers['Content-Type'] = 'application/json' if body

      {headers: headers, body: body, query: query}.compact
    end

    def voice_response
      {
        body: '{"_embedded": {"calls":[]}}', 
        headers: response_headers
      }
    end

    def applications_response
      {
        body: '{"_embedded": {"applications":[]}}', 
        headers: response_headers
      }
    end

    def secrets_response
      {
        body: '{"_embedded": {"secrets":[]}}', 
        headers: response_headers
      }
    end

    def numbers_response
      {
        body: '{"numbers":[]}', 
        headers: response_headers
      }
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

    def country
      'GB'
    end

    def prefix
      '44'
    end

    def conversation_id
      'CON-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def call_id
      'CALL-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def user_id
      'USR-xxxxxx'
    end

    def member_id
      'MEM-xxxxxx'
    end

    alias_method :call_uuid, :call_id
  end
end
