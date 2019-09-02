# frozen_string_literal: true

module Nexmo
  class Applications < Namespace
    self.authentication = Basic

    self.request_body = JSON

    self.request_headers['Content-Type'] = 'application/json'

    # Create an application.
    #
    # @example
    #   params = {
    #     name: 'Example App',
    #     type: 'voice',
    #     answer_url: answer_url,
    #     event_url: event_url
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
    def create(params)
      request('/v2/applications', params: params, type: Post)
    end

    # List available applications.
    #
    # @example
    #   response = client.applications.list
    #   response._embedded.applications.each do |item|
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
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/application.v2#listApplication
    #
    def list(params = nil)
      request('/v2/applications', params: params)
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
    def delete(id)
      request('/v2/applications/' + id, type: Delete)
    end
  end
end
