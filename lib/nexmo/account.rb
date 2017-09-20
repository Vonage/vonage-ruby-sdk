# frozen_string_literal: true

module Nexmo
  class Account < Namespace
    def balance
      request('/account/get-balance')
    end

    def update(params)
      request('/account/settings', params: params, type: Post)
    end

    def topup(params)
      request('/account/top-up', params: params, type: Post)
    end

    private

    def host
      'rest.nexmo.com'
    end
  end
end
