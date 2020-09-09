# typed: strict
# frozen_string_literal: true

module Vonage
  class Applications < Namespace
    extend T::Sig
    self.authentication = Basic

    self.request_body = JSON

    self.request_headers['Content-Type'] = 'application/json'

    # Create an application.
    #
    # @example
    #   params = {
    #     name: 'Example App',
    #     capabilities: {
    #       'messages': {
    #         'webhooks': {
    #           'inbound_url': {
    #             'address': 'https://example.com/webhooks/inbound',
    #             'http_method': 'POST'
    #           },
    #           'status_url': {
    #             'address': 'https://example.com/webhooks/status',
    #             'http_method': 'POST'
    #           }
    #         }
    #       }
    #     }
    #   }
    #
    #   response = client.applications.create(params)
    #
    # @option params [required, String] :name
    #   Application name.
    #
    # @option params [Hash] :keys
    #   - **:public_key** (String) Public key
    #
    # @option params [Hash] :capabilities
    #   Your application can use multiple products.
    #   This contains the configuration for each product.
    #   This replaces the application `type` from version 1 of the Application API.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/application.v2#createApplication
    #
    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Vonage::Response) }
    def create(params)
      request('/v2/applications', params: params, type: Post)
    end

    # List available applications.
    #
    # @example
    #   response = client.applications.list
    #   response.each do |item|
    #     puts "#{item.id} #{item.name}"
    #   end
    #
    # @option params [Integer] :page_size
    #   The number of applications per page.
    #
    # @option params [Integer] :page
    #   The current page number (starts at 1).
    #
    # @param [Hash] params
    #
    # @return [ListResponse]
    #
    # @see https://developer.nexmo.com/api/application.v2#listApplication
    #
    sig { params(params: T.nilable(T::Hash[Symbol, Integer])).returns(Vonage::Response) }
    def list(params = nil)
      request('/v2/applications', params: params, response_class: ListResponse)
    end

    # Get an application.
    #
    # @example
    #   response = client.applications.get(id)
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/application.v2#getApplication
    #
    sig { params(id: String).returns(Vonage::Response) }
    def get(id)
      request('/v2/applications/' + id)
    end

    # Update an application.
    #
    # @example
    #   response = client.applications.update(id, answer_method: 'POST')
    #
    # @option params [required, String] :name
    #   Application name.
    #
    # @option params [Hash] :keys
    #   - **:public_key** (String) Public key
    #
    # @option params [Hash] :capabilities
    #   Your application can use multiple products.
    #   This contains the configuration for each product.
    #   This replaces the application `type` from version 1 of the Application API.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/application.v2#updateApplication
    #
    sig { params(
      id: String,
      params: T::Hash[Symbol, T.untyped]
    ).returns(Vonage::Response) }
    def update(id, params)
      request('/v2/applications/' + id, params: params, type: Put)
    end

    # Delete an application.
    #
    # @example
    #   response = client.applications.delete(id)
    #
    # @note Deleting an application cannot be undone.
    #
    # @param [String] id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/application.v2#deleteApplication
    #
    sig { params(id: String).returns(Vonage::Response) }
    def delete(id)
      request('/v2/applications/' + id, type: Delete)
    end
  end
end
