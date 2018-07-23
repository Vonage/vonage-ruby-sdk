# frozen_string_literal: true

module Nexmo
  class SMS < Namespace
    include Keys

    self.host = 'rest.nexmo.com'

    def send(params)
      request('/sms/json', params: hyphenate(params), type: Post)
    end
  end
end
