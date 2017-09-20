# frozen_string_literal: true

module Nexmo
  class Numbers < Namespace
    def list(params)
      request('/account/numbers', params: params)
    end

    def search(params)
      request('/number/search', params: params)
    end

    def buy(params)
      request('/number/buy', params: params, type: Post)
    end

    def cancel(params)
      request('/number/cancel', params: params, type: Post)
    end

    def update(params)
      request('/number/update', params: params, type: Post)
    end

    private

    def host
      'rest.nexmo.com'
    end
  end
end
