# typed: true
# frozen_string_literal: true

module Vonage
  class Secrets < Namespace
    self.authentication = Basic

    self.request_body = JSON

    # Create API Secret.
    #
    # @example
    #   response = client.secrets.create(secret: 'T0ps3cr3t')
    #
    # @option params [required, String] :secret
    #   The new secret must follow these rules:
    #   - minimum 8 characters
    #   - maximum 25 characters
    #   - minimum 1 lower case character
    #   - minimum 1 upper case character
    #   - minimum 1 digit
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/account#createAPISecret
    #
    def create(params)
      request('/accounts/' + account_id + '/secrets', params: params, type: Post)
    end

    # Retrieve API Secrets.
    #
    # @example
    #   response = client.secrets.list
    #   response.each do |item|
    #     puts "#{item.created_at} #{item.id}"
    #   end
    #
    # @return [ListResponse]
    #
    # @see https://developer.nexmo.com/api/account#retrieveAPISecrets
    #
    def list
      request('/accounts/' + account_id + '/secrets', response_class: ListResponse)
    end

    # Retrieve one API Secret.
    #
    # @example
    #   response = client.secrets.get(secret_id)
    #
    # @param [String] secret_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/account#retrieveAPISecret
    #
    def get(secret_id)
      request('/accounts/' + account_id + '/secrets/' + secret_id)
    end

    # Revoke an API Secret.
    #
    # @example
    #   response = client.secrets.revoke(secret_id)
    #
    # @param [String] secret_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/account#revokeAPISecret
    #
    def revoke(secret_id)
      request('/accounts/' + account_id + '/secrets/' + secret_id, type: Delete)
    end

    private

    def account_id
      @config.api_key
    end
  end
end
