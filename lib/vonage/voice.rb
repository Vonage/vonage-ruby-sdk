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
    #
    # @option params [required, Hash] :from
    #   Connect to a Phone (PSTN) number.
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
    # @param [Hash] params
    #
    # @return [ListResponse]
    #
    # @see https://developer.nexmo.com/api/voice#getCalls
    #
    def list(params = nil)
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
  end
end
