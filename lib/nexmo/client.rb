require 'net/http'
require 'json'

module Nexmo
  class Client
    attr_accessor :key, :secret, :auth_token, :user_agent

    def initialize(options = {})
      @key = options.fetch(:key) { ENV['NEXMO_API_KEY'] }

      @secret = options.fetch(:secret) { ENV['NEXMO_API_SECRET'] }

      @signature_secret = options.fetch(:signature_secret) { ENV['NEXMO_SIGNATURE_SECRET'] }

      @application_id = options[:application_id]

      @private_key = options[:private_key]

      @host = options.fetch(:host) { 'rest.nexmo.com' }

      @api_host = options.fetch(:api_host) { 'api.nexmo.com' }

      @user_agent = UserAgent.string(options[:app_name], options[:app_version])
    end

    def authorization
      'Bearer ' + (auth_token || generate_auth_token)
    end

    def send_message(params)
      post(@host, '/sms/json', params)
    end

    def track_message_conversion(message_id, params = {})
      post(@api_host, '/conversions/sms', {'message-id' => message_id}.merge(params))
    end

    def track_voice_conversion(message_id, params = {})
      post(@api_host, '/conversions/voice', {'message-id' => message_id}.merge(params))
    end

    def get_balance
      get(@host, '/account/get-balance')
    end

    def get_country_pricing(country_code)
      get(@host, '/account/get-pricing/outbound', country: country_code)
    end

    def get_prefix_pricing(prefix)
      get(@host, '/account/get-prefix-pricing/outbound', prefix: prefix)
    end

    def get_sms_pricing(number)
      get(@host, '/account/get-phone-pricing/outbound/sms', phone: number)
    end

    def get_voice_pricing(number)
      get(@host, '/account/get-phone-pricing/outbound/voice', phone: number)
    end

    def update_settings(params)
      post(@host, '/account/settings', params)
    end

    def topup(params)
      post(@host, '/account/top-up', params)
    end

    def get_account_numbers(params)
      get(@host, '/account/numbers', params)
    end

    def get_available_numbers(country_code, params = {})
      get(@host, '/number/search', {country: country_code}.merge(params))
    end

    def buy_number(params)
      post(@host, '/number/buy', params)
    end

    def cancel_number(params)
      post(@host, '/number/cancel', params)
    end

    def update_number(params)
      post(@host, '/number/update', params)
    end

    def get_message(id)
      get(@host, '/search/message', id: id)
    end

    def get_message_rejections(params)
      get(@host, '/search/rejections', params)
    end

    def search_messages(params)
      get(@host, '/search/messages', Hash === params ? params : {ids: Array(params)})
    end

    def send_2fa_message(params)
      post(@host, '/sc/us/2fa/json', params)
    end

    def send_event_alert_message(params)
      post(@host, '/sc/us/alert/json', params)
    end

    def send_marketing_message(params)
      post(@host, '/sc/us/marketing/json', params)
    end

    def get_event_alert_numbers
      get(@host, '/sc/us/alert/opt-in/query/json')
    end

    def resubscribe_event_alert_number(params)
      post(@host, '/sc/us/alert/opt-in/manage/json', params)
    end

    def initiate_call(params)
      Kernel.warn "#{self.class}##{__method__} is deprecated (use the Voice API instead)."

      post(@host, '/call/json', params)
    end

    def initiate_tts_call(params)
      Kernel.warn "#{self.class}##{__method__} is deprecated (use the Voice API instead)."

      post(@api_host, '/tts/json', params)
    end

    def initiate_tts_prompt_call(params)
      Kernel.warn "#{self.class}##{__method__} is deprecated (use the Voice API instead)."

      post(@api_host, '/tts-prompt/json', params)
    end

    def start_verification(params)
      post(@api_host, '/verify/json', params)
    end

    def check_verification(request_id, params)
      post(@api_host, '/verify/check/json', params.merge(request_id: request_id))
    end

    def get_verification(request_id)
      get(@api_host, '/verify/search/json', request_id: request_id)
    end

    def cancel_verification(request_id)
      post(@api_host, '/verify/control/json', request_id: request_id, cmd: 'cancel')
    end

    def trigger_next_verification_event(request_id)
      post(@api_host, '/verify/control/json', request_id: request_id, cmd: 'trigger_next_event')
    end

    def get_basic_number_insight(params)
      get(@api_host, '/ni/basic/json', params)
    end

    def get_standard_number_insight(params)
      get(@api_host, '/ni/standard/json', params)
    end

    def get_advanced_number_insight(params)
      get(@api_host, '/ni/advanced/json', params)
    end

    def get_advanced_async_number_insight(params)
      get(@api_host, '/ni/advanced/async/json', params)
    end

    def request_number_insight(params)
      post(@host, '/ni/json', params)
    end

    def get_applications(params = {})
      get(@api_host, '/v1/applications', params)
    end

    def get_application(id)
      get(@api_host, "/v1/applications/#{id}")
    end

    def create_application(params)
      post(@api_host, '/v1/applications', params)
    end

    def update_application(id, params)
      put(@api_host, "/v1/applications/#{id}", params)
    end

    def delete_application(id)
      delete(@api_host, "/v1/applications/#{id}")
    end

    def create_call(params)
      api_request(Net::HTTP::Post, '/v1/calls', params)
    end

    def get_calls(params = nil)
      api_request(Net::HTTP::Get, '/v1/calls', params)
    end

    def get_call(uuid)
      api_request(Net::HTTP::Get, "/v1/calls/#{uuid}")
    end

    def update_call(uuid, params)
      api_request(Net::HTTP::Put, "/v1/calls/#{uuid}", params)
    end

    def send_audio(uuid, params)
      api_request(Net::HTTP::Put, "/v1/calls/#{uuid}/stream", params)
    end

    def stop_audio(uuid)
      api_request(Net::HTTP::Delete, "/v1/calls/#{uuid}/stream")
    end

    def send_speech(uuid, params)
      api_request(Net::HTTP::Put, "/v1/calls/#{uuid}/talk", params)
    end

    def stop_speech(uuid)
      api_request(Net::HTTP::Delete, "/v1/calls/#{uuid}/talk")
    end

    def send_dtmf(uuid, params)
      api_request(Net::HTTP::Put, "/v1/calls/#{uuid}/dtmf", params)
    end

    def get_file(id)
      api_request(Net::HTTP::Get, "/v1/files/#{id.split('/').last}")
    end

    def save_file(id, filename)
      api_request(Net::HTTP::Get, "/v1/files/#{id.split('/').last}") do |response|
        File.open(filename, 'wb') do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
      end
    end

    def check_signature(params)
      unless @signature_secret
        raise AuthenticationError.new('No signature_secret provided. ' \
          'You can find your signature secret in the Nexmo dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/signing-messages for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      Signature.check(params, @signature_secret)
    end

    private

    def get(host, request_uri, params = {})
      uri = URI('https://' + host + request_uri)
      uri.query = Params.encode(params.merge(api_key_and_secret))

      message = Net::HTTP::Get.new(uri.request_uri)

      request(uri, message)
    end

    def post(host, request_uri, params)
      uri = URI('https://' + host + request_uri)

      message = Net::HTTP::Post.new(uri.request_uri)
      message.form_data = params.merge(api_key_and_secret)

      request(uri, message)
    end

    def put(host, request_uri, params)
      uri = URI('https://' + host + request_uri)

      message = Net::HTTP::Put.new(uri.request_uri)
      message['Content-Type'] = 'application/json'
      message.body = JSON.generate(params.merge(api_key_and_secret))

      request(uri, message)
    end

    def delete(host, request_uri)
      uri = URI('https://' + host + request_uri)
      uri.query = Params.encode(api_key_and_secret)

      message = Net::HTTP::Delete.new(uri.request_uri)

      request(uri, message)
    end

    def api_request(message_class, path, params = nil, &block)
      uri = URI('https://' + @api_host + path)

      unless message_class::REQUEST_HAS_BODY || params.nil? || params.empty?
        uri.query = Params.encode(params)
      end

      message = message_class.new(uri.request_uri)

      if message_class::REQUEST_HAS_BODY
        message['Content-Type'] = 'application/json'
        message.body = JSON.generate(params)
      end

      token = auth_token || generate_auth_token

      message['Authorization'] = "Bearer #{token}"

      request(uri, message, &block)
    end

    def request(uri, message)
      http = Net::HTTP.new(uri.host, Net::HTTP.https_default_port)
      http.use_ssl = true

      message['User-Agent'] = @user_agent

      http_response = http.request(message)

      case http_response
      when Net::HTTPNoContent
        :no_content
      when Net::HTTPSuccess
        return (yield http_response) if block_given?

        if http_response['Content-Type'].split(';').first == 'application/json'
          JSON.parse(http_response.body, object_class: Nexmo::Entity)
        else
          http_response.body
        end
      when Net::HTTPUnauthorized
        raise AuthenticationError, "#{http_response.code} response from #{uri.host}"
      when Net::HTTPClientError
        raise ClientError, "#{http_response.code} response from #{uri.host}"
      when Net::HTTPServerError
        raise ServerError, "#{http_response.code} response from #{uri.host}"
      else
        raise Error, "#{http_response.code} response from #{uri.host}"
      end
    end

    def api_key_and_secret
      unless @key
        raise AuthenticationError.new('No API key provided. ' \
          'See https://developer.nexmo.com/concepts/guides/authentication for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      unless @secret
        raise AuthenticationError.new('No API secret provided. ' \
          'See https://developer.nexmo.com/concepts/guides/authentication for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      {api_key: @key, api_secret: @secret}
    end

    def generate_auth_token
      unless @application_id
        raise AuthenticationError.new('No application_id provided. ' \
          'Either provide an application_id, or set an auth token. ' \
          'You can add new applications from the Nexmo dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/applications for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      unless @private_key
        raise AuthenticationError.new('No private_key provided. ' \
          'Either provide a private_key, or set an auth token. ' \
          'You can add new applications from the Nexmo dashboard. ' \
          'See https://developer.nexmo.com/concepts/guides/applications for details, ' \
          'or email support@nexmo.com if you have any questions.')
      end

      JWT.generate({application_id: @application_id}, @private_key)
    end
  end
end
