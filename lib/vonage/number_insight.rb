# typed: true
# frozen_string_literal: true

module Vonage
  class NumberInsight < Namespace
    # Provides basic number insight information about a number.
    #
    # @example
    #   response = client.number_insight.basic(number: '447700900000')
    #
    # @option params [required, String] :number
    #   A single phone number that you need insight about in national or international format.
    #
    # @option params [String] :country
    #   If a number does not have a country code or is uncertain, set the two-character country code.
    #   This code must be in ISO 3166-1 alpha-2 format and in upper case. For example, GB or US.
    #   If you set country and number is already in E.164 format, country must match the country code in number.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/number-insight#getNumberInsightBasic
    #
    def basic(params)
      response = request('/ni/basic/json', params: params)

      raise Error, response[:status_message] unless response.status.zero?

      response
    end

    # Provides standard number insight information about a number.
    #
    # @example
    #   response = client.number_insight.standard(number: '447700900000')
    #
    # @option params [required, String] :number
    #   A single phone number that you need insight about in national or international format.
    #
    # @option params [String] :country
    #   If a number does not have a country code or is uncertain, set the two-character country code.
    #   This code must be in ISO 3166-1 alpha-2 format and in upper case. For example, GB or US.
    #   If you set country and number is already in E.164 format, country must match the country code in number.
    #
    # @option params [Boolean] :cnam
    #   Indicates if the name of the person who owns the phone number should be looked up and returned in the response.
    #   Set to true to receive phone number owner name in the response.
    #   This features is available for US numbers only and incurs an additional charge.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/number-insight#getNumberInsightStandard
    #
    def standard(params)
      response = request('/ni/standard/json', params: params)

      raise Error, response[:status_message] unless response.status.zero?

      response
    end

    # Provides advanced number insight information about a number synchronously.
    #
    # @example
    #   response = client.number_insight.advanced(number: '447700900000')
    #
    # @option params [required, String] :number
    #   A single phone number that you need insight about in national or international format.
    #
    # @option params [String] :country
    #   If a number does not have a country code or is uncertain, set the two-character country code.
    #   This code must be in ISO 3166-1 alpha-2 format and in upper case. For example, GB or US.
    #   If you set country and number is already in E.164 format, country must match the country code in number.
    #
    # @option params [Boolean] :cnam
    #   Indicates if the name of the person who owns the phone number should be looked up and returned in the response.
    #   Set to true to receive phone number owner name in the response.
    #   This features is available for US numbers only and incurs an additional charge.
    #
    # @option params [String] :ip
    #   The IP address of the user.
    #   If supplied, we will compare this to the country the user's phone is located in and return an error if it does not match.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/number-insight#getNumberInsightAdvanced
    #
    def advanced(params)
      response = request('/ni/advanced/json', params: params)

      raise Error, response[:status_message] unless response.status.zero?

      response
    end

    # Provides advanced number insight number information *asynchronously* using the URL specified in the callback parameter.
    #
    # @example
    #   response = client.number_insight.advanced_async(number: '447700900000', callback: webhook_url)
    #
    # @option params [required, String] :callback
    #   The callback URL.
    #
    # @option params [required, String] :number
    #   A single phone number that you need insight about in national or international format.
    #
    # @option params [String] :country
    #   If a number does not have a country code or is uncertain, set the two-character country code.
    #   This code must be in ISO 3166-1 alpha-2 format and in upper case. For example, GB or US.
    #   If you set country and number is already in E.164 format, country must match the country code in number.
    #
    # @option params [Boolean] :cnam
    #   Indicates if the name of the person who owns the phone number should be looked up and returned in the response.
    #   Set to true to receive phone number owner name in the response.
    #   This features is available for US numbers only and incurs an additional charge.
    #
    # @option params [String] :ip
    #   The IP address of the user.
    #   If supplied, we will compare this to the country the user's phone is located in and return an error if it does not match.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/number-insight#getNumberInsightAsync
    #
    def advanced_async(params)
      response = request('/ni/advanced/async/json', params: params)

      raise Error, response[:status_message] unless response.status.zero?

      response
    end
  end
end
