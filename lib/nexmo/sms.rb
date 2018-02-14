# frozen_string_literal: true

module Nexmo
  class SMS < Namespace
    include Keys

    def send(params)
      request('/sms/json', params: hyphenate(params), type: Post)
    end

    private

    def host
      'rest.nexmo.com'
    end
  end
end
