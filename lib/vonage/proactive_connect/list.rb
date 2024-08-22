# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::List < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_body = JSON

    # Create list
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.list.create(name: 'List Number 1')
    #
    # @param [required, String] :name
    #   A name for the list
    #
    # @param [optional, String] :description
    #   A description of the list
    #
    # @param [optional, Array] :tags
    #   An Array of up to 10 Strings assigining tags to the list. Each String must be between 1 and 15 characters
    #
    # @param [optional, Array] :attributes
    #   Array of Hash objects. Each Hash represents an attribute for the list.
    #
    # @option attributes [required, String] :name
    #   The name of the attribute
    #
    # @option attributes [optional, String] :alias
    #   Alternative name to use for this attribute.
    #   Use when you wish to correlate between 2 or more list that are using different attribute names for the same semantic data
    #
    # @option attributes [optional, Boolean] :key
    #   Set to `true` if this attribute should be used to correlate between 2 or more lists. Default is `false`
    #
    # @param [optional, Hash] :datasource
    #   Datasource for the list
    #
    # @option datasource [required, String] :type
    #   Must be set to `manual`, which is the default
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#listsCreate
    #
    def create(name:, **params)
      logger.info('This method is deprecated and will be removed in a future release.')
      request(
        "/v0.1/bulk/lists",
        params: params.merge({ name: name }),
        type: Post
      )
    end

    # Get list by id
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.list.find(id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865')
    #
    # @param [required, String] :id
    #   Unique identifier for the list
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#listsGet
    #
    def find(id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request("/v0.1/bulk/lists/#{id}")
    end

    # Update list
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.list.update(name: 'List Number 1')
    #
    # @param [required, String] :id
    #   The id of the list to update
    #
    # @param [required, String] :name
    #   The name of the list
    #
    # @param [optional, String] :description
    #   A description of the list
    #
    # @param [optional, Array] :tags
    #   An Array of up to 10 Strings assigining tags to the list. Each String must be between 1 and 15 characters
    #
    # @param [optional, Array] :attributes
    #   Array of Hash objects. Each Hash represents an attribute for the list.
    #
    # @option attributes [required, String] :name
    #   The name of the attribute
    #
    # @option attributes [optional, String] :alias
    #   Alternative name to use for this attribute.
    #   Use when you wish to correlate between 2 or more list that are using different attribute names for the same semantic data
    #
    # @option attributes [optional, Boolean] :key
    #   Set to `true` if this attribute should be used to correlate between 2 or more lists. Default is `false`
    #
    # @param [optional, Hash] :datasource
    #   Datasource for the list
    #
    # @option datasource [required, String] :type
    #   Must be set to `manual`, which is the default
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#listsUpdate
    #
    def update(id:, name:, **params)
      logger.info('This method is deprecated and will be removed in a future release.')
      request(
        "/v0.1/bulk/lists/#{id}",
        params: params.merge({ name: name }),
        type: Put
      )
    end

    # Delete a list by id
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.list.delete(id: '74ea1ecf-06c9-4072-a285-61677bd353e8')
    #
    # @param [required, String] :id
    #   Unique identifier for the list
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#listsDelete
    #
    def delete(id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request(
        "/v0.1/bulk/lists/#{id}",
        type: Delete
      )
    end

    # Clear list by deleting all items
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.list.clear_items(id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865')
    #
    # @param [required, String] :id
    #   Unique identifier for the list
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#listsClear
    #
    def clear_items(id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request(
        "/v0.1/bulk/lists/#{id}/clear",
        type: Post
      )
    end

    # Fetch and replace all items from datasource
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.list.fetch_and_replace_items(id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865')
    #
    # @param [required, String] :id
    #   Unique identifier for the list
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#listsFetch
    #
    def fetch_and_replace_items(id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request(
        "/v0.1/bulk/lists/#{id}/fetch",
        type: Post
      )
    end
  end
end
