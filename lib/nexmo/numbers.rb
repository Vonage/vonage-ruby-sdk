# frozen_string_literal: true

module Nexmo
  class Numbers < Namespace
    include Keys

    self.host = 'rest.nexmo.com'

    # Retrieve all the inbound numbers associated with your Nexmo account.
    #
    # @example
    #   response = client.numbers.list
    #   response.numbers.each do |item|
    #     puts "#{item.msisdn} #{item.country} #{item.type}"
    #   end
    #
    # @option params [Integer] :index
    #   Page index.
    #
    # @option params [Integer] :size
    #   Page size.
    #
    # @option params [String] :pattern
    #   The number pattern you want to search for. Use in conjunction with **:search_pattern**.
    #
    # @option params [Integer] :search_pattern
    #   The strategy you want to use for matching:
    #   - `0` - Search for numbers that start with **:pattern**
    #   - `1` - Search for numbers that contain **:pattern**
    #   - `2` - Search for numbers that end with **:pattern**
    #
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/developer/numbers#getOwnedNumbers
    #
    def list(params = nil)
      request('/account/numbers', params: params)
    end

    # Retrieve inbound numbers that are available for the specified country.
    #
    # @example
    #   response = client.numbers.search(country: 'GB')
    #   response.numbers.each do |item|
    #     puts "#{item.msisdn} #{item.type} #{item.cost}"
    #   end
    #
    # @option params [required, String] :country
    #   The two character country code in ISO 3166-1 alpha-2 format.
    #
    # @option params [String] :type
    #   Set this parameter to filter the type of number, such as mobile or landline.
    #
    # @option params [String] :pattern
    #   The number pattern you want to search for.
    #   Use in conjunction with **:search_pattern**.
    #
    # @option params [Integer] :search_pattern
    #   The strategy you want to use for matching:
    #   - `0` - Search for numbers that start with **:pattern**
    #   - `1` - Search for numbers that contain **:pattern**
    #   - `2` - Search for numbers that end with **:pattern**
    #
    # @option params [String] :features
    #   Available features are `SMS` and `VOICE`.
    #   To look for numbers that support both, use a comma-separated value: `SMS,VOICE`.
    #
    # @option params [Integer] :size
    #   Page size.
    #
    # @option params [Integer] :index
    #   Page index.
    #
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/developer/numbers#getAvailableNumbers
    #
    def search(params)
      request('/number/search', params: params)
    end

    # Request to purchase a specific inbound number.
    #
    # @example
    #   response = client.numbers.buy(country: 'GB', msisdn: '447700900000')
    #
    # @option params [required, String] :country
    #   The two character country code in ISO 3166-1 alpha-2 format.
    #
    # @option params [required, String] :msisdn
    #   An available inbound virtual number.
    #
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/developer/numbers#buyANumber
    #
    def buy(params)
      request('/number/buy', params: params, type: Post)
    end

    # Cancel your subscription for a specific inbound number.
    #
    # @example
    #   response = client.numbers.cancel(country: 'GB', msisdn: '447700900000')
    #
    # @option params [required, String] :country
    #   The two character country code in ISO 3166-1 alpha-2 format.
    #
    # @option params [required, String] :msisdn
    #   An available inbound virtual number.
    #
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/developer/numbers#cancelANumber
    #
    def cancel(params)
      request('/number/cancel', params: params, type: Post)
    end

    # Change the behaviour of a number that you own.
    #
    # @example
    #   params = {
    #     country: 'GB',
    #     msisdn: '447700900000',
    #     voice_callback_type: 'app',
    #     voice_callback_value: application_id
    #   }
    #
    #   response = client.numbers.update(params)
    #
    # @option params [required, String] :country
    #   The two character country code in ISO 3166-1 alpha-2 format.
    #
    # @option params [required, String] :msisdn
    #   An available inbound virtual number.
    #
    # @option params [String] :mo_http_url
    #   An URL-encoded URI to the webhook endpoint that handles inbound messages.
    #   Your webhook endpoint must be active before you make this request.
    #   Nexmo makes a `GET` request to the endpoint and checks that it returns a `200 OK` response.
    #   Set this parameter's value to an empty string to remove the webhook.
    #
    # @option params [String] :mo_smpp_sys_type
    #   The associated system type for your SMPP client.
    #
    # @option params [String] :messages_callback_type
    #   The SMS webhook type (always `app`).
    #   Must be used with the **:messages_callback_value** option.
    #
    # @option params [String] :messages_callback_value
    #   A Nexmo Application ID.
    #   Must be used with the **:messages_callback_type** option.
    #
    # @option params [String] :voice_callback_type
    #   The voice webhook type.
    #   Must be used with the **:voice_callback_value** option.
    #
    # @option params [String] :voice_callback_value
    #   A SIP URI, telephone number or Application ID.
    #   Must be used with the **:voice_callback_type** option.
    #
    # @option params [String] :voice_status_callback
    #   A webhook URI for Nexmo to send a request to when a call ends.
    #
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/developer/numbers#updateANumber
    #
    def update(params)
      request('/number/update', params: camelcase(params), type: Post)
    end
  end
end
