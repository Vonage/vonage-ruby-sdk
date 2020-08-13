# typed: strict
# frozen_string_literal: true

module Vonage
  class Verify < Namespace
    extend T::Sig
    alias_method :http_request, :request

    private :http_request

    # Generate and send a PIN to your user.
    #
    # @note You can make a maximum of one Verify request per second.
    #
    # @example
    #   response = client.verify.request(number: '447700900000', brand: 'Acme Inc')
    #
    #   puts "Started verification request_id=#{response.request_id}"
    #
    # @option params [required, String] :number
    #   The mobile or landline phone number to verify.
    #   Unless you are setting **:country** explicitly, this number must be in E.164 format.
    #
    # @option params [String] :country
    #   If you do not provide **:number** in international format or you are not sure if **:number** is correctly formatted, specify the two-character country code in **:country**.
    #   Verify will then format the number for you.
    #
    # @option params [required, String] :brand
    #   An 18-character alphanumeric string you can use to personalize the verification request SMS body, to help users identify your company or application name.
    #   For example: "Your `Acme Inc` PIN is ..."
    #
    # @option params [String] :sender_id
    #   An 11-character alphanumeric string that represents the [identity of the sender](https://developer.nexmo.com/messaging/sms/guides/custom-sender-id) of the verification request.
    #   Depending on the destination of the phone number you are sending the verification SMS to, restrictions might apply.
    #
    # @option params [Integer] :code_length
    #   The length of the verification code.
    #
    # @option params [String] :lg
    #   By default, the SMS or text-to-speech (TTS) message is generated in the locale that matches the **:number**.
    #   For example, the text message or TTS message for a `33*` number is sent in French.
    #   Use this parameter to explicitly control the language, accent and gender used for the Verify request.
    #
    # @option params [Integer] :pin_expiry
    #   How log the generated verification code is valid for, in seconds.
    #   When you specify both **:pin_expiry** and **:next_event_wait** then **:pin_expiry** must be an integer multiple of **:next_event_wait** otherwise **:pin_expiry** is defaulted to equal **:next_event_wait**.
    #   See [changing the event timings](https://developer.nexmo.com/verify/guides/changing-default-timings).
    #
    # @option params [Integer] :next_event_wait
    #   Specifies the wait time in seconds between attempts to deliver the verification code.
    #
    # @option params [Integer] :workflow_id
    #   Selects the predefined sequence of SMS and TTS (Text To Speech) actions to use in order to convey the PIN to your user.
    #   For example, an id of 1 identifies the workflow SMS - TTS - TTS.
    #   For a list of all workflows and their associated ids, please visit the [developer portal](https://developer.nexmo.com/verify/guides/workflows-and-events).
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/verify#verifyRequest
    #
    sig { params(params: T.untyped, uri: T.untyped).returns(T.untyped) }
    def request(params, uri = '/verify/json')
      response = http_request(uri, params: params, type: Post)

      raise Error, response[:error_text] if error?(response)

      response
    end

    # Confirm that the PIN you received from your user matches the one sent by Vonage in your verification request.
    #
    # @example
    #   response = client.verify.check(request_id: request_id, code: '1234')
    #
    #   puts "Verification complete, event_id=#{response.event_id}"
    #
    # @option params [required, String] :request_id
    #   The Verify request to check.
    #   This is the `request_id` you received in the response to the Verify request.
    #
    # @option params [required, String] :code
    #   The verification code entered by your user.
    #
    # @option params [String] :ip_address
    #   The IP address used by your user when they entered the verification code.
    #   Vonage uses this information to identify fraud and spam. This ultimately benefits all Vonage customers.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/verify#verifyCheck
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def check(params)
      response = http_request('/verify/check/json', params: params, type: Post)

      raise Error, response[:error_text] if error?(response)

      response
    end

    # Check the status of past or current verification requests.
    #
    # @example
    #   response = client.verify.search(request_id: request_id)
    #
    # @option params [String] :request_id
    #   The `request_id` you received in the Verify Request Response.
    #
    # @option params [Array<string>] :request_ids
    #   More than one `request_id`.
    #   Each `request_id` is a new parameter in the Verify Search request.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/verify#verifySearch
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(T.any(T::Hash[Symbol, T.untyped], Vonage::Response)) }
    def search(params)
      response = http_request('/verify/search/json', params: params)

      raise Error, response[:error_text] if error?(response)

      response
    end

    # Control the progress of your verification requests.
    #
    # @example
    #   response = client.verify.control(request_id: request_id, cmd: 'cancel')
    #
    # @option params [required, String] :request_id
    #   The `request_id` you received in the response to the Verify request.
    #
    # @option params [required, String] :cmd
    #   The command to execute, depending on whether you want to cancel the verification process, or advance to the next verification event.
    #   You must wait at least 30 seconds before cancelling a Verify request.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/verify#verifyControl
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
    def control(params)
      response = http_request('/verify/control/json', params: params, type: Post)

      raise Error, response[:error_text] if error?(response)

      response
    end

    # Cancel an existing verification request.
    #
    # @example
    #   response = client.verify.cancel(request_id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/verify#verifyControl
    #
    sig { params(id: String).returns(Vonage::Response) }
    def cancel(id)
      control(request_id: id, cmd: 'cancel')
    end

    # Trigger the next verification event for an existing verification request.
    #
    # @example
    #   response = client.verify.trigger_next_event(request_id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/verify#verifyControl
    #
    sig { params(id: String).returns(Vonage::Response) }
    def trigger_next_event(id)
      control(request_id: id, cmd: 'trigger_next_event')
    end

    # Send a PSD2-compliant payment token to a user for payment authorization
    #
    # @example
    #   response = client.verify.psd2(number: '447700900000', payee: 'Acme Inc', amount: 48.00)
    #
    # @option params [required, String] :number
    #   The mobile or landline phone number to verify.
    #   Unless you are setting **:country** explicitly, this number must be in E.164 format.
    #
    # @option params [String] :country
    #   If you do not provide **:number** in international format or you are not sure if **:number** is correctly formatted, specify the two-character country code in **:country**.
    #   Verify will then format the number for you.
    #
    # @option params [required, String] :payee
    #   An alphanumeric string to indicate to the user the name of the recipient that they are confirming a payment to.
    #
    # @option params [required, Float] :amount
    #   The decimal amount of the payment to be confirmed, in Euros
    #
    # @option params [Integer] :code_length
    #   The length of the verification code.
    #
    # @option params [String] :lg
    #   By default, the SMS or text-to-speech (TTS) message is generated in the locale that matches the **:number**.
    #   For example, the text message or TTS message for a `33*` number is sent in French.
    #   Use this parameter to explicitly control the language, accent and gender used for the Verify request.
    #
    # @option params [Integer] :pin_expiry
    #   How log the generated verification code is valid for, in seconds.
    #   When you specify both **:pin_expiry** and **:next_event_wait** then **:pin_expiry** must be an integer multiple of **:next_event_wait** otherwise **:pin_expiry** is defaulted to equal **:next_event_wait**.
    #   See [changing the event timings](https://developer.nexmo.com/verify/guides/changing-default-timings).
    #
    # @option params [Integer] :next_event_wait
    #   Specifies the wait time in seconds between attempts to deliver the verification code.
    #
    # @option params [Integer] :workflow_id
    #   Selects the predefined sequence of SMS and TTS (Text To Speech) actions to use in order to convey the PIN to your user.
    #   For example, an id of 1 identifies the workflow SMS - TTS - TTS.
    #   For a list of all workflows and their associated ids, please visit the [developer portal](https://developer.nexmo.com/verify/guides/workflows-and-events).
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/verify#verifyRequestWithPSD2
    #
    sig { params(params: T.untyped, uri: T.untyped).returns(T.any(Vonage::Error, Vonage::Response)) }
    def psd2(params, uri = '/verify/psd2/json')
      response = http_request(uri, params: params, type: Post)

      raise Error, response[:error_text] if error?(response)

      response
    end

    private

    sig { params(response: T.untyped).returns(T::Boolean) }
    def error?(response)
      response.respond_to?(:error_text)
    end
  end
end
