# typed: false
# frozen_string_literal: true

module Nexmo
  class TFA < Namespace
    include Keys

    self.host = 'rest.nexmo.com'

    def send(params)
      request('/sc/us/2fa/json', params: hyphenate(params), type: Post)
    end
  end
end
