# typed: true
# frozen_string_literal: true

module Vonage
  class Voice < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    # Create an outbound Call.
    #
    # @example
    #   response = client.voice.create({
    #     to: [{type: 'phone', number: '14843331234'}],
    #     from: {type: 'phone', number: '14843335555'},
    #     answer_url: ['https://example.com/answer']
    #   })
    #
    # @option params [required, Array<Hash>] :to
    #   Connect to a Phone (PSTN) number, SIP Endpoint, Websocket, or VBC extension.
    #   The `to` Hash can contain a number of different properties depending on the `type`.
    #   See the API reference for specific details.
    #
    # @option params [Hash] :from
    #   Connect to a Phone (PSTN) number. Should not be set if **:random_from_number** is **true**
    #   If not set, then **:random_from_number** will automatically be set to **true**
    #
    # @option params [Boolean] :random_from_number
    #   Set to **true** to use random phone number as **from**. The number will be selected from the list
    #   of the numbers assigned to the current application.
    #   **random_from_number: true** cannot be used together with **:from**.
    #
    # @option params [Array<String>] :ncco
    #   The Vonage Call Control Object to use for this call.
    #   Required unless **:answer_url** is provided.
    #
    # @option params [Array<String>] :answer_url
    #   The webhook endpoint where you provide the Vonage Call Control Object that governs this call.
    #   Required unless **:ncco** is provided.
    #
    # @option params [String] :answer_method
    #   The HTTP method used to send event information to answer_url.
    #
    # @option params [required, Array<String>] :event_url
    #   The webhook endpoint where call progress events are sent to.
    #
    # @option params [String] :event_method
    #   The HTTP method used to send event information to event_url.
    #
    # @option params [String] :machine_detection
    #   Configure the behavior when Vonage detects that the call is answered by voicemail.
    #
    # @option params [Hash] :advanced_machine_detection
    #   Configure the behavior of Vonage's advanced machine detection. Overrides machine_detection if both are set.
    #   Hash with three possible properties:
    #     - :behavior [String]: Must be one of `continue` or `hangup`. When hangup is used, the call will be terminated if a
    #         machine is detected. When continue is used, the call will continue even if a machine is detected.
    #     - :mode [String]: Must be one of `detect` or `detect_beep`. Detect if machine answered and sends a human or
    #         machine status in the webhook payload. When set to `detect_beep`, the system also attempts to detect
    #         voice mail beep and sends an additional parameter `sub_state` in the webhook with the value `beep_start`.
    #     - :beep_timeout [Integer]: Min: 45, Max: 120. Maximum time in seconds Vonage should wait for a machine beep
    #         to be detected. A machine event with `sub_state` set to `beep_timeout` will be sent if the timeout is exceeded.
    #
    # @option params [Integer] :length_timer
    #   Set the number of seconds that elapse before Vonage hangs up after the call state changes to in_progress.
    #
    # @option params [Integer] :ringing_timer
    #   Set the number of seconds that elapse before Vonage hangs up after the call state changes to `ringing`.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#createCall
    #
    def create(params)
      if params.key?(:from) && params[:random_from_number] == true
        raise ClientError.new("`from` should not be set if `random_from_number` is `true`")
      end

      if params && !params.key?(:from)
        params.merge!(random_from_number: true)
      end

      request('/v1/calls', params: params, type: Post)
    end

    # Get details of your calls.
    #
    # @example
    #   response = client.voice.list
    #   response.each do |item|
    #     puts "#{item.uuid} #{item.direction} #{item.status}"
    #   end
    #
    # @option params [String] :status
    #   Filter by call status.
    #
    # @option params [String] :date_start
    #   Return the records that occurred after this point in time.
    #
    # @option params [String] :date_end
    #   Return the records that occurred before this point in time.
    #
    # @option params [Integer] :page_size
    #   Return this amount of records in the response.
    #
    # @option params [Integer] :record_index
    #   Return calls from this index in the response.
    #
    # @option params [String] :order
    #   Either `ascending` or `descending` order.
    #
    # @option params [String] :conversation_uuid
    #   Return all the records associated with a specific conversation.
    #
    # @option params [Boolean] :auto_advance
    #   Set this to `false` to not auto-advance through all the pages in the record
    #   and collect all the data. The default is `true`.
    #
    # @param [Hash] params
    #
    # @return [ListResponse]
    #
    # @see https://developer.nexmo.com/api/voice#getCalls
    #
    def list(params = nil, auto_advance = true)
      if params && !params.key?(:auto_advance)
        params.merge!(auto_advance: true)
      end

      request('/v1/calls', params: params, response_class: ListResponse)
    end

    # Get detail of a specific call.
    #
    # @example
    #   response = client.voice.get(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#getCall
    #
    def get(id)
      request('/v1/calls/' + id)
    end

    # Modify an in progress call.
    #
    # @example
    #   response = client.voice.update(id, action: 'hangup')
    #
    # @option params [required, String] :action
    #
    # @option params [Hash] :destination
    #   Required when **:action** is `transfer`.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#updateCall
    #
    def update(id, params)
      request('/v1/calls/' + id, params: params, type: Put)
    end

    # Hangup an in progress call.
    #
    # @example
    #   response = client.voice.hangup(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#updateCall
    #
    def hangup(id)
      update(id, action: 'hangup')
    end

    # Mute an in progress call.
    #
    # @example
    #   response = client.voice.mute(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#updateCall
    #
    def mute(id)
      update(id, action: 'mute')
    end

    # Unmute an in progress call.
    #
    # @example
    #   response = client.voice.unmute(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#updateCall
    #
    def unmute(id)
      update(id, action: 'unmute')
    end

    # Earmuff an in progress call.
    #
    # @example
    #   response = client.voice.earmuff(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#updateCall
    #
    def earmuff(id)
      update(id, action: 'earmuff')
    end

    # Unearmuff an in progress call.
    #
    # @example
    #   response = client.voice.unearmuff(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#updateCall
    #
    def unearmuff(id)
      update(id, action: 'unearmuff')
    end

    # Transfer an in progress call.
    #
    # @example
    #   destination = {
    #     type: 'ncco',
    #     url: ['https://example.com/ncco.json']
    #   }
    #
    #   response = client.voice.transfer(id, destination: destination)
    #
    # @param [String] id
    # @param [Hash] destination
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/voice#updateCall
    #
    def transfer(id, destination:)
      update(id, action: 'transfer', destination: destination)
    end

    # @return [Stream]
    #
    def stream
      @stream ||= Stream.new(@config)
    end

    # @return [Talk]
    #
    def talk
      @talk ||= Talk.new(@config)
    end

    # @return [DTMF]
    #
    def dtmf
      @dtmf ||= DTMF.new(@config)
    end

    # Validate a JSON Web Token from a Voice API Webhook.
    #
    # @param [String, required] :token The JWT from the Webhook's Authorization header
    # @param [String, optional] :signature_secret The account signature secret. Required, unless `signature_secret`
    #   is set in `Config`
    #
    # @return [Boolean] true, if the JWT is verified, false otherwise
    def verify_webhook_token(token:, signature_secret: @config.signature_secret)
      JWT.verify_hs256_signature(token: token, signature_secret: signature_secret)
    end
  end
end
