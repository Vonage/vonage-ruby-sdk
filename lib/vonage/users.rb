# typed: strict
# frozen_string_literal: true

module Vonage
  class Users < Namespace
    extend T::Sig
    self.authentication = BearerToken

    self.request_body = JSON

    # Get a list of Users associated with the Vonage Application.
    #
    # @param [optional, Integer] :page_size
    #   Specifies the number of records to be returned in the response.
    #
    # @param [optional, String] :order
    #   Specifies the order in which the records should be returned.
    #   Must be one of `asc`, `ASC`, `desc`, or `DESC`
    #
    # @param [optional, String] :cursor
    #   Specficy a cursor point from which to start returning results, for example the values of the `next` or `prev`
    #   `_links` contained in a response.
    #
    # @param [optional, String] :name
    #   Specify a user name with which to filter results
    #
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/application.v2#getUsers
    #
    def list(**params)
      request('/v1/users', params: params, response_class: ListResponse)
    end

    # Get a specified User associated with the Vonage Application.
    #
    # @param [required, String] :id
    #   The unique ID or name for the user.
    #
    # @return [Vonage::Response]
    #
    # @see https://developer.vonage.com/en/api/application.v2#getUser
    #
    def find(id:)
      request("/v1/users/#{id}")
    end

    # Create a new User associated with the Vonage Application.
    #
    # @param [optional, String] :name
    #   A unique name for the user. If not provided, a name will be auto-generated.
    #
    # @param [optional, String] :display_name
    #   A string to be displayed as user name. It does not need to be unique.
    #
    # @param [optional, String] :image_url
    #   A publicly accessible URL to an image file for an image to be associated with the user.
    #
    # @param [optional, Hash] :properties A hash defining properties for the User.
    #   @option properties [Hash] :custom_data A hash of custom data as key/value pairs.
    #
    # @param [optional, Hash] :channels A hash defining details of various channels.
    #   @option channels [Array] :pstn An array containing a Hash which defines data for the pstn channel.
    #     @option pstn [Integer] :number The pstn number.
    #   @option channels [Array] :sip An array containing a Hash which defines data for the sip channel.
    #     @option sip [String] :uri The sip uri.
    #     @option sip [String] :username The sip username.
    #     @option sip [String] :password The sip password.
    #   @option channels [Array] :vbc An array containing a Hash which defines data for the vbc channel.
    #     @option vbc [String] :extension The vbc extension.
    #   @option channels [Array] :websocket An array containing a Hash which defines data for the websocket channel.
    #     @option websocket [String] :uri The websocket uri.
    #     @option websocket [String] :content-type The websocket audio type. Must be one of: `audio/l16;rate=8000`, `audio/l16;rate=16000`.
    #     @option websocket [Hash] :headers A hash of custom websocket headers provided as key/value pairs.
    #   @option channels [Array] :sms An array containing a Hash which defines data for the sms channel.
    #     @option sms [Integer] :number The sms number.
    #   @option channels [Array] :mms An array containing a Hash which defines data for the mms channel.
    #     @option mms [Integer] :number The mms number.
    #   @option channels [Array] :whatsapp An array containing a Hash which defines data for the whatsapp channel.
    #     @option whatsapp [Integer] :number The whatsapp number.
    #   @option channels [Array] :viber An array containing a Hash which defines data for the sms channel.
    #     @option viber [Integer] :number The viber number.
    #   @option channels [Array] :messenger An array containing a Hash which defines data for the messenger channel.
    #     @option messenger [Integer] :id The messenger id.
    #
    # @return [Vonage::Response]
    #
    # @see https://developer.vonage.com/en/api/application.v2#createUser
    #
    def create(**params)
      request('/v1/users', params: params, type: Post)
    end

    # Update an existing User associated with the Vonage Application.
    #
    # @param [required, String] :id
    #   The unique ID or name for the user to be updated.
    #
    # @param [optional, String] :name
    #   A unique name for the user.
    #
    # @param [optional, String] :display_name
    #   A string to be displayed as user name. It does not need to be unique.
    #
    # @param [optional, String] :image_url
    #   A publicly accessible URL to an image file for an image to be associated with the user.
    #
    # @param [optional, Hash] :properties A hash defining properties for the User.
    #   @option properties [Hash] :custom_data A hash of custom data as key/value pairs.
    #
    # @param [optional, Hash] :channels A hash defining details of various channels.
    #   @option channels [Array] :pstn An array containing a Hash which defines data for the pstn channel.
    #     @option pstn [Integer] :number The pstn number.
    #   @option channels [Array] :sip An array containing a Hash which defines data for the sip channel.
    #     @option sip [String] :uri The sip uri.
    #     @option sip [String] :username The sip username.
    #     @option sip [String] :password The sip password.
    #   @option channels [Array] :vbc An array containing a Hash which defines data for the vbc channel.
    #     @option vbc [String] :extension The vbc extension.
    #   @option channels [Array] :websocket An array containing a Hash which defines data for the websocket channel.
    #     @option websocket [String] :uri The websocket uri.
    #     @option websocket [String] :content-type The websocket audio type. Must be one of: `audio/l16;rate=8000`, `audio/l16;rate=16000`.
    #     @option websocket [Hash] :headers A hash of custom websocket headers provided as key/value pairs.
    #   @option channels [Array] :sms An array containing a Hash which defines data for the sms channel.
    #     @option sms [Integer] :number The sms number.
    #   @option channels [Array] :mms An array containing a Hash which defines data for the mms channel.
    #     @option mms [Integer] :number The mms number.
    #   @option channels [Array] :whatsapp An array containing a Hash which defines data for the whatsapp channel.
    #     @option whatsapp [Integer] :number The whatsapp number.
    #   @option channels [Array] :viber An array containing a Hash which defines data for the sms channel.
    #     @option viber [Integer] :number The viber number.
    #   @option channels [Array] :messenger An array containing a Hash which defines data for the messenger channel.
    #     @option messenger [Integer] :id The messenger id.
    #
    # @return [Vonage::Response]
    #
    # @see https://developer.vonage.com/en/api/application.v2#createUser
    #
    def update(id:, **params)
      request("/v1/users/#{id}", params: params, type: Patch)
    end

    # Delete a specified User associated with the Vonage Application.
    #
    # @param [required, String] :id
    #   The unique ID or name for the user.
    #
    # @return [Vonage::Response]
    #
    # @see https://developer.vonage.com/en/api/application.v2#deleteUser
    #
    def delete(id:)
      request("/v1/users/#{id}", type: Delete)
    end
  end
end
