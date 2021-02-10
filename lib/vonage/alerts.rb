# typed: strict
# frozen_string_literal: true

module Vonage
  class Alerts < Namespace
    extend T::Sig
    self.host = :rest_host

    # Request the list of phone numbers opted out from your campaign.
    #
    # @see https://developer.nexmo.com/api/sms/us-short-codes/alerts/subscription
    #
    # @return [Response]
    #
    sig { returns(Vonage::Response) }
    def list
      request('/sc/us/alert/opt-in/query/json')
    end

    # Remove a phone number from the opt-out list.
    #
    # @option params [required, String] :msisdn
    #   The phone number to resubscribe to your campaign and remove from the opt-out list.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/sms/us-short-codes/alerts/subscription
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def remove(params)
      request('/sc/us/alert/opt-in/manage/json', params: params, type: Post)
    end

    alias_method :resubscribe, :remove

    # Send an alert to your user.
    #
    # @option params [required, String] :to
    #   The single phone number to send pin to.
    #   Mobile number in US format and one recipient per request.
    #
    # @option params [Integer] :status_report_req
    #   Set to 1 to receive a delivery receipt.
    #   To receive the delivery receipt, you have to configure a webhook endpoint in Dashboard.
    #
    # @option params [String] :client_ref
    #   A 40 character reference string for your internal reporting.
    #
    # @option params [Integer] :template
    #   If you have multiple templates, this is the index of the template to call.
    #   The default template starts is 0, each Event Based Alert campaign can have up to 6 templates.
    #   If you have one template only it is the default. That is, template=0.
    #   If you create a request with template=1 the API call will default, template=0 instead.
    #   After you add a valid campaign alert for 2FA, the request will call template 1 instead of template 0.
    #
    # @option params [String] :type
    #   Default value is `text`. Possible values are: `text` for plain text SMS or `unicode` only use this when your SMS must contain special characters.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/sms/us-short-codes/alerts/sending
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def send(params)
      request('/sc/us/alert/json', params: params, type: Post)
    end
  end
end
