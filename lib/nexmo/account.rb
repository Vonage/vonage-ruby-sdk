# frozen_string_literal: true

module Nexmo
  class Account < Namespace
    include Keys

    self.host = 'rest.nexmo.com'

    # Retrieve your account balance.
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/developer/account#get-balance
    #
    def balance
      request('/account/get-balance')
    end

    # Update the default callback URLs (where the webhooks are sent to) associated with your account.
    #
    # @note The URLs you provide must be valid and active. Nexmo will check that they return a 200 OK response before the setting is saved.
    #
    # @option params [String] :mo_call_back_url
    #   The URL where Nexmo will send a webhook when an SMS is received to a Nexmo number that does not have SMS handling configured.
    #   Send an empty string to unset this value.
    #
    # @option params [String] :dr_call_back_url
    #   The URL where Nexmo will send a webhook when an delivery receipt is received without a specific callback URL configured.
    #   Send an empty string to unset this value.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/developer/account#settings
    #
    def update(params)
      request('/account/settings', params: camelcase(params), type: Post)
    end

    # Top-up your account balance.
    #
    # @option params [required, String] :trx
    #   The ID associated with your original auto-reload transaction.
    #
    # @param [Hash] params
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/developer/account#top-up
    #
    def topup(params)
      request('/account/top-up', params: params, type: Post)
    end
  end
end
