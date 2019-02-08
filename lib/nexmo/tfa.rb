# frozen_string_literal: true

module Nexmo
  class TFA < Namespace
    self.host = 'rest.nexmo.com'

    def send(params)
      request('/sc/us/2fa/json', params: params, type: Post)
    end
  end
end
