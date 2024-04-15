# typed: false
require "simplecov"

SimpleCov.start { add_filter "test/vonage" }

if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "minitest/autorun"
require "webmock/minitest"
require "timecop"
require "vonage"

module Vonage
  class Test < Minitest::Test
    def setup
      super

      @request_stubs = []
    end

    def stub_request(*args)
      super.tap { |stub| @request_stubs << stub }
    end

    def teardown
      @request_stubs.each { |stub| assert_requested(stub, at_least_times: 1) }

      super
    end

    def api_key
      "vonage-api-key"
    end

    def api_secret
      "vonage-api-secret"
    end

    def api_key_and_secret
      { api_key: api_key, api_secret: api_secret }
    end

    def signature_secret
      "Vonage-signature-secret"
    end

    def application_id
      "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    end

    def private_key
      File.read(
        File.expand_path(
          File.join(File.dirname(__FILE__), "..", "private_key.txt")
        )
      )
    end

    def sample_webhook_token
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1ODc0OTQ5NjIsImp0aSI6ImM1YmE4ZjI0LTFhMTQtNGMxMC1iZmRmLTNmYmU4Y2U1MTFiNSIsImlzcyI6IlZvbmFnZSIsInBheWxvYWRfaGFzaCI6ImQ2YzBlNzRiNTg1N2RmMjBlM2I3ZTUxYjMwYzBjMmE0MGVjNzNhNzc4NzliNmYwNzRkZGM3YTIzMTdkZDAzMWIiLCJhcGlfa2V5IjoiYTFiMmMzZCIsImFwcGxpY2F0aW9uX2lkIjoiYWFhYWFhYWEtYmJiYi1jY2NjLWRkZGQtMDEyMzQ1Njc4OWFiIn0.JQRKi1d0SQitmjPINfTWMpt3XZkGsLbD7EjCdXoNSbk"
    end

    def sample_video_token
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE3MTMxNzc4NTAsImp0aSI6IjYzMmI5NmMwLTM0MzEtNGI5NS1iNmNiLWNjNGFjNDEzNDhkNSIsImV4cCI6MTcxMzE3ODc1MCwiYXBwbGljYXRpb25faWQiOiJlMzM2ZmUxOS01MWNhLTRiNTktYTczOS1jNzA3MWIzZjY5Y2MiLCJzY29wZSI6InNlc3Npb24uY29ubmVjdCIsInNlc3Npb25faWQiOiIxX01YNWxNek0yWm1VeE9TMDFNV05oTFRSaU5Ua3RZVGN6T1Mxak56QTNNV0l6WmpZNVkyTi1makUzTURJME9ETTVNakV6TVRaLVNVeFdLMnh4ZFUxR1VESTJlbFZWVkcxUE9FTnlUVzVSZm41LSIsInJvbGUiOiJtb2RlcmF0b3IiLCJpbml0aWFsX2xheW91dF9jbGFzc19saXN0IjoiIiwic3ViIjoidmlkZW8iLCJhY2wiOnsicGF0aHMiOnsiL3Nlc3Npb24vKioiOnt9fX19.kHj4lHKxWKurScu6LWm7z0G69WuLHyx-Vgf3CDlCYdRRAqJ--SRXPukAAGuA52wvou4wVStd6BWCiSUDxjNb6wG5li3Op6RDdpIiooJ6C1kVdUmbEgBLww76Vy34If0d99XbEZX13KW0XmN6oyrNSih3paanqYzjJcG9elKxnMXLhnTB8Mq6OQXVAiB4Qr6LCqdB57a1eU52Ak2-1F41p3LnzDaElFOepbCdFtIXiFxjd3r62JXiYMNxQCseT2RyPqcKQsFUSBV6k3GvY8ONece-ClSED_prXkChW1o3_7sRsfFqBaQiCGjw4vtIIE17S4atv4Z5rzBPLvUsqpUfog"
    end

    def sample_valid_signature_secret
      "ZYtdTtGV3BCFN7tWmOWr1md66XsquMggr4W2cTtXtcPgfnI0Xw"
    end

    def sample_invalid_signature_secret
      "ZYtdTtGV3BCFN7tWmOWr1md66XsquMggr4W2cTtXtcPgf55555"
    end

    def config
      @config ||=
        Vonage::Config.new.merge(
          {
            api_key: api_key,
            api_secret: api_secret,
            signature_secret: signature_secret,
            application_id: application_id,
            private_key: private_key
          }
        )
    end

    def headers
      { "Content-Type" => "application/x-www-form-urlencoded" }
    end

    def bearer_token
      /\ABearer (.+)\.(.+)\.(.+)\z/
    end

    def authorization
      bearer_token
    end

    def basic_authorization
      "Basic dm9uYWdlLWFwaS1rZXk6dm9uYWdlLWFwaS1zZWNyZXQ="
    end

    def meetings_host
      "api-eu.vonage.com"
    end

    def vonage_host
      "api-eu.vonage.com"
    end

    def request(body: nil, query: nil, headers: {}, auth: nil)
      headers['Authorization'] = auth || authorization
      headers['Content-Type'] = 'application/json' if body

      { headers: headers, body: body, query: query }.compact
    end

    def video_session_id
      '1_MX4xMjM0NTZ-fk1vbiBNYXIgMTcgMDA6NDE6MzEgUERUIDIwMTR-MC42ODM3ODk1MzQ0OTQyODA4fg'
    end

    def video_list_response
      {
        body: '{"items":[]}',
        headers: response_headers
      }
    end

    def voice_response
      { body: '{"_embedded": {"calls":[]}}', headers: response_headers }
    end

    def applications_response
      { body: '{"_embedded": {"applications":[]}}', headers: response_headers }
    end

    def conversation_list_response
      { body: '{"_embedded": {"conversations":[]}}', headers: response_headers }
    end

    def session_list_response
      { body: '{"_embedded": {"sessions":[]}}', headers: response_headers }
    end

    def members_list_response
      { body: '{"_embedded": {"members":[]}}', headers: response_headers }
    end

    def events_list_response
      { body: '{"_embedded": []}', headers: response_headers }
    end

    def secrets_response
      { body: '{"_embedded": {"secrets":[]}}', headers: response_headers }
    end

    def users_response
      { body: '{"_embedded": {"users":[]}}', headers: response_headers }
    end

    def numbers_response
      { body: '{"numbers":[]}', headers: response_headers }
    end

    def numbers_response_paginated_page_1
      {
        body:
          '{
                 "count": 14,
                 "numbers":[
                   {
                    "country": "GB",
                    "msisdn": "447700900000",
                    "type": "mobile-lvn",
                    "cost": "1.25",
                    "features": [
                      "VOICE",
                      "SMS",
                      "MMS"
                    ]
                    },
                    {
                     "country": "GB",
                     "msisdn": "447700900001",
                     "type": "mobile-lvn",
                     "cost": "1.25",
                     "features": [
                       "VOICE",
                       "SMS",
                       "MMS"
                     ]
                    },
                    {
                     "country": "GB",
                     "msisdn": "447700900002",
                     "type": "mobile-lvn",
                     "cost": "1.25",
                     "features": [
                       "VOICE",
                       "SMS",
                       "MMS"
                      ]
                     },
                     {
                      "country": "GB",
                      "msisdn": "447700900003",
                      "type": "mobile-lvn",
                      "cost": "1.25",
                      "features": [
                        "VOICE",
                        "SMS",
                        "MMS"
                      ]
                     },
                     {
                      "country": "GB",
                      "msisdn": "447700900004",
                      "type": "mobile-lvn",
                      "cost": "1.25",
                      "features": [
                        "VOICE",
                        "SMS",
                        "MMS"
                       ]
                     },
                     {
                      "country": "GB",
                      "msisdn": "447700900005",
                      "type": "mobile-lvn",
                      "cost": "1.25",
                      "features": [
                        "VOICE",
                        "SMS",
                        "MMS"
                      ]
                      },
                      {
                       "country": "GB",
                       "msisdn": "447700900006",
                       "type": "mobile-lvn",
                       "cost": "1.25",
                       "features": [
                         "VOICE",
                         "SMS",
                         "MMS"
                       ]
                      },
                      {
                       "country": "GB",
                       "msisdn": "447700900007",
                       "type": "mobile-lvn",
                       "cost": "1.25",
                       "features": [
                         "VOICE",
                         "SMS",
                         "MMS"
                        ]
                       },
                       {
                        "country": "GB",
                        "msisdn": "447700900008",
                        "type": "mobile-lvn",
                        "cost": "1.25",
                        "features": [
                          "VOICE",
                          "SMS",
                          "MMS"
                        ]
                       },
                       {
                        "country": "GB",
                        "msisdn": "447700900009",
                        "type": "mobile-lvn",
                        "cost": "1.25",
                        "features": [
                          "VOICE",
                          "SMS",
                          "MMS"
                         ]
                       }
                      ]
                    }',
        headers: response_headers
      }
    end

    def numbers_response_paginated_page_2
      {
        body:
          '{
                 "count": 14,
                 "numbers":[
                      {
                       "country": "GB",
                       "msisdn": "447700900010",
                       "type": "mobile-lvn",
                       "cost": "1.25",
                       "features": [
                         "VOICE",
                         "SMS",
                         "MMS"
                       ]
                      },
                      {
                       "country": "GB",
                       "msisdn": "447700900011",
                       "type": "mobile-lvn",
                       "cost": "1.25",
                       "features": [
                         "VOICE",
                         "SMS",
                         "MMS"
                        ]
                       },
                       {
                        "country": "GB",
                        "msisdn": "447700900012",
                        "type": "mobile-lvn",
                        "cost": "1.25",
                        "features": [
                          "VOICE",
                          "SMS",
                          "MMS"
                        ]
                       },
                       {
                        "country": "GB",
                        "msisdn": "447700900013",
                        "type": "mobile-lvn",
                        "cost": "1.25",
                        "features": [
                          "VOICE",
                          "SMS",
                          "MMS"
                         ]
                       }
                      ]
                    }',
        headers: response_headers
      }
    end

    def meetings_rooms_list_response_single
      { headers: response_headers, body: '{"_embedded":[{"key":"value"}]}' }
    end

    def meetings_rooms_list_response_multiple
      {
        headers: response_headers,
        body:
          '{"_embedded":[{"key":"value"}, {"key":"value"}, {"key":"value"}]}'
      }
    end

    def response
      { body: '{"key":"value"}', headers: response_headers }
    end

    def response_headers
      { "Content-Type" => "application/json;charset=utf-8" }
    end

    def msisdn
      "447700900000"
    end

    def country
      "GB"
    end

    def prefix
      "44"
    end

    def conversation_id
      "CON-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    end

    def call_id
      "CALL-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    end

    def meetings_id
      "MEET-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    end

    def video_id
      'VIDEO-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def video_connection_id
      'VIDEO-CONNECT-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def user_id
      "USR-xxxxxx"
    end

    def member_id
      "MEM-xxxxxx"
    end

    def e164_compliant_number
      '447000000000'
    end

    def invalid_number
      'abcdefg'
    end

    alias_method :call_uuid, :call_id
  end
end
