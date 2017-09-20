# frozen_string_literal: true

module Nexmo
  class SMS < Namespace
    def send(params)
      request('/sms/json', params: params, type: Post)
    end

    private

    def host
      'rest.nexmo.com'
    end
  end
end
