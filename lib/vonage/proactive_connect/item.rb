# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Item < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_body = JSON

    # Create a list item
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.item.create(list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865', data: {name: 'Joe Bloggs', email: 'joe@email.com'})
    #
    # @param [required, String] :list_id
    #   Unique identifier for the list
    #
    # @param [required, Hash] :data
    #   A hash of data containing the item's data attributes and values
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#itemsCreate
    #
    def create(list_id:, data:)
      logger.info('This method is deprecated and will be removed in a future release.')
      raise ArgumentError.new(":data must be a Hash") unless data.is_a? Hash
      request(
        "/v0.1/bulk/lists/#{list_id}/items",
        params: { data: data },
        type: Post
      )
    end

    # Get list item by id
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.item.find(list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865', item_id: 'd97ebf20-e4de-4e50-921a-7bb4dceb373a')
    #
    # @param [required, String] :list_id
    #   Unique identifier for the list
    #
    # @param [required, String] :item_id
    #   Unique identifier for the item
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#itemsGet
    #
    def find(list_id:, item_id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request("/v0.1/bulk/lists/#{list_id}/items/#{item_id}")
    end

    # Update list item
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.item.create(
    #     list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865',
    #     item_id: 'd97ebf20-e4de-4e50-921a-7bb4dceb373a',
    #     data: {name: 'Jane Bloggs', email: 'joe@email.com'}
    #   )
    #
    # @param [required, String] :list_id
    #   Unique identifier for the list
    #
    # @param [required, String] :item_id
    #   Unique identifier for the item
    #
    # @param [required, Hash] :data
    #   A hash of data containing the item's data attributes and values
    #   All attributes for the item must be passed, even ones for which the value is not changing.
    #     If an attribute is omitted, existing data for that attribute will be deleted.
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#itemsUpdate
    #
    def update(list_id:, item_id:, data:)
      logger.info('This method is deprecated and will be removed in a future release.')
      raise ArgumentError.new(":data must be a Hash") unless data.is_a? Hash
      request(
        "/v0.1/bulk/lists/#{list_id}/items/#{item_id}",
        params: { data: data },
        type: Put
      )
    end

    #  Delete list item
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.item.delete(list_id: 'e546eebe-8e23-4e4d-bb7c-29d4700c9865', item_id: 'd97ebf20-e4de-4e50-921a-7bb4dceb373a')
    #
    # @param [required, String] :list_id
    #   Unique identifier for the list
    #
    # @param [required, String] :item_id
    #   Unique identifier for the item
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#itemsDelete
    #
    def delete(list_id:, item_id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request(
        "/v0.1/bulk/lists/#{list_id}/items/#{item_id}",
        type: Delete
      )
    end
  end
end
