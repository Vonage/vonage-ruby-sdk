# frozen_string_literal: true

module Nexmo
  class Secrets < Namespace
    self.authentication = Basic

    self.request_body = JSON

    def create(params)
      request('/accounts/' + account_id + '/secrets', params: params, type: Post)
    end

    def list
      request('/accounts/' + account_id + '/secrets')
    end

    def get(secret_id)
      request('/accounts/' + account_id + '/secrets/' + secret_id)
    end

    def revoke(secret_id)
      request('/accounts/' + account_id + '/secrets/' + secret_id, type: Delete)
    end

    private

    def account_id
      @client.api_key
    end
  end
end
