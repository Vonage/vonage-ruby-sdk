# frozen_string_literal: true

module Nexmo
  class Account < Namespace
    self.host = 'rest.nexmo.com'

    def balance
      request('/account/get-balance')
    end

    def update(params)
      request('/account/settings', params: params, type: Post)
    end

    def topup(params)
      request('/account/top-up', params: params, type: Post)
    end
  end
end
