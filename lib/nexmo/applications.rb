# frozen_string_literal: true

module Nexmo
  class Applications < Namespace
    self.request_body = JSON

    # Create a new application.
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
    #   The name of your application.
    #
    # @option params [required, String] :type
    #   The Nexmo product or products that you access with this application.
    #   Currently only `voice` and `messages` are supported.
    #
    # @option params [required, String] :answer_url
    #   The URL where your webhook delivers the Nexmo Call Control Object that governs this call.
    #   As soon as your user answers a call Nexmo makes a request to answer_url.
    #
    # @option params [String] :answer_method
    #   The HTTP method used to make the request to answer_url.
    #   The default value is GET.
    #
    # @option params [required, String] :event_url
    #   Nexmo sends event information asynchronously to this URL when status changes.
    #
    # @option params [String] :event_method
    #   The HTTP method used to send event information to event_url.
    #   The default value is POST.
    #
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/application#create-an-application
    #
    def create(params)
      request('/v1/applications', params: params, type: Post)
    end

    # Retrieve details of all applications associated with your account.
    #
    # @example
    #   response = client.applications.list
    #   response._embedded.applications.each do |item|
    #     puts "#{item.id} #{item.name}"
    #   end
    #
    # @option params [Integer] :page_size
    #   Set the number of items returned on each call to this endpoint.
    #   The default is 10 records.
    #
    # @option params [Integer] :page_index
    #   Set the offset from the first page.
    #   The default value is 0.
    #
    # @param [Hash, nil] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/application#retrieve-your-applications
    #
    def list(params = nil)
      request('/v1/applications', params: params)
    end

    # Retrieve details about a single application.
    #
    # @example
    #   response = client.applications.get(id)
    #
    # @param [String] id
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/application#retrieve-an-application
    #
    def get(id)
      request('/v1/applications/' + id)
    end

    # Update an existing application.
    #
    # @example
    #   response = client.applications.update(id, answer_method: 'POST')
    #
    # @option params [required, String] :name
    #   The name of your application.
    #
    # @option params [required, String] :type
    #   The Nexmo product or products that you access with this application.
    #   Currently only `voice` and `messages` are supported.
    #
    # @option params [required, String] :answer_url
    #   The URL where your webhook delivers the Nexmo Call Control Object that governs this call.
    #   As soon as your user answers a call Nexmo makes a request to answer_url.
    #
    # @option params [String] :answer_method
    #   The HTTP method used to make the request to answer_url.
    #   The default value is GET.
    #
    # @option params [required, String] :event_url
    #   Nexmo sends event information asynchronously to this URL when status changes.
    #
    # @option params [String] :event_method
    #   The HTTP method used to send event information to event_url.
    #   The default value is POST.
    #
    # @param [String] id
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/application#update-an-application
    #
    def update(id, params)
      request('/v1/applications/' + id, params: params, type: Put)
    end

    # Delete a single application.
    #
    # @example
    #   response = client.applications.delete(id)
    #
    # @param [String] id
    #
    # @return [:no_content]
    #
    # @see https://developer.nexmo.com/api/application#destroy-an-application
    #
    def delete(id)
      request('/v1/applications/' + id, type: Delete)
    end
  end
end
