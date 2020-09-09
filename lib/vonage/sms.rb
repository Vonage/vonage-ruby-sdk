# typed: strict
# frozen_string_literal: true

module Vonage
  class SMS < Namespace
    extend T::Sig
    include Keys

    self.host = :rest_host

    # Send an outbound SMS from your Vonage account.
    #
    # @example
    #   response = client.sms.send(from: 'Ruby', to: '447700900000', text: 'Hello world')
    #
    #   puts "Sent message id=#{response.messages.first.message_id}"
    #
    # @option params [required, String] :from
    #   The name or number the message should be sent from.
    #   Alphanumeric senderID's are not supported in all countries, see [Global Messaging](https://developer.nexmo.com/messaging/sms/guides/global-messaging#country-specific-features) for more details.
    #   If alphanumeric, spaces will be ignored. Numbers are specified in E.164 format.
    #
    # @option params [required, String] :to
    #   The number that the message should be sent to.
    #   Numbers are specified in E.164 format.
    #
    # @option params [String] :text
    #   The body of the message being sent.
    #   If your message contains characters that can be encoded according to the GSM Standard and Extended tables then you can set the **:type** to `text`.
    #   If your message contains characters outside this range, then you will need to set the **:type** to `unicode`.
    #
    # @option params [Integer] :ttl
    #   The duration in milliseconds the delivery of an SMS will be attempted.
    #   By default Vonage attempt delivery for 72 hours, however the maximum effective value depends on the operator and is typically 24 - 48 hours.
    #   We recommend this value should be kept at its default or at least 30 minutes.
    #
    # @option params [Boolean] :status_report_req
    #   Boolean indicating if you like to receive a [Delivery Receipt](https://developer.nexmo.com/messaging/sms/building-blocks/receive-a-delivery-receipt).
    #
    # @option params [String] :callback
    #   The webhook endpoint the delivery receipt for this sms is sent to.
    #   This parameter overrides the webhook endpoint you set in Dashboard.
    #
    # @option params [Integer] :message_class
    #   The Data Coding Scheme value of the message.
    #
    # @option params [String] :type
    #   The format of the message body.
    #
    # @option params [String] :vcard
    #   A business card in [vCard format](https://en.wikipedia.org/wiki/VCard).
    #   Depends on **:type** option having the value `vcard`.
    #
    # @option params [String] :vcal
    #   A calendar event in [vCal format](https://en.wikipedia.org/wiki/VCal).
    #   Depends on **:type** option having the value `vcal`.
    #
    # @option params [String] :body
    #   Hex encoded binary data.
    #   Depends on **:type** option having the value `binary`.
    #
    # @option params [String] :udh
    #   Your custom Hex encoded [User Data Header](https://en.wikipedia.org/wiki/User_Data_Header).
    #   Depends on **:type** option having the value `binary`.
    #
    # @option params [Integer] :protocol_id
    #   The value of the [protocol identifier](https://en.wikipedia.org/wiki/GSM_03.40#Protocol_Identifier) to use.
    #   Ensure that the value is aligned with **:udh**.
    #
    # @option params [String] :title
    #   The title for a wappush SMS.
    #   Depends on **:type** option having the value `wappush`.
    #
    # @option params [String] :url
    #   The URL of your website.
    #   Depends on **:type** option having the value `wappush`.
    #
    # @option params [String] :validity
    #   The availability for an SMS in milliseconds.
    #   Depends on **:type** option having the value `wappush`.
    #
    # @option params [String] :client_ref
    #   You can optionally include your own reference of up to 40 characters.
    #
    # @option params [String] :account_ref
    #   An optional string used to identify separate accounts using the SMS endpoint for billing purposes.
    #   To use this feature, please email [support@nexmo.com](mailto:support@nexmo.com).
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/sms#send-an-sms
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def send(params)
      if unicode?(params.fetch(:text)) && params[:type] != 'unicode'
        message = 'Sending unicode text SMS without setting the type parameter to "unicode". ' \
          'See https://developer.nexmo.com/messaging/sms for details, ' \
          'or email support@nexmo.com if you have any questions.'

        logger.warn(message)
      end

      response = request('/sms/json', params: hyphenate(params), type: Post)

      unless response.messages.first.status == '0'
        raise Error, response.messages.first[:error_text]
      end

      response
    end

    private

    sig { params(text: String).returns(T::Boolean) }
    def unicode?(text)
      !Vonage::GSM7.encoded?(text)
    end
  end
end
