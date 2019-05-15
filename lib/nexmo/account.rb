# frozen_string_literal: true

module Nexmo
  class Account < Namespace
    self.host = 'rest.nexmo.com'

    # Retrieve your account balance.
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/developer/account#get-balance
    #
    def balance
      request('/account/get-balance')
    end

    # Modify settings for your account including callback URLs and your API secret.
    #
    # @option params [String] :moCallBackUrl
    #   The URL where Nexmo will send a webhook when an SMS is received to a Nexmo number that does not have SMS handling configured.
    #
    # @option params [String] :drCallBackUrl
    #   The URL where Nexmo will send a webhook when an delivery receipt is received without a specific callback URL configured.
    #
    # @param [Hash] params
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/developer/account#settings
    #
    def update(params)
      request('/account/settings', params: params, type: Post)
    end

    # Top-up your account balance.
    #
    # @option params [required, String] :trx
    #   The ID associated with your original auto-reload transaction.
    #
    # @param [Hash] params
    #
    # @see https://developer.nexmo.com/api/developer/account#top-up
    #
    def topup(params)
      request('/account/top-up', params: params, type: Post)
    end
  end
end
