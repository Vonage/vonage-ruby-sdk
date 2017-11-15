# frozen_string_literal: true

module Nexmo
  class Conversions < Namespace
    include Keys

    def track_sms(params)
      request('/conversions/sms', params: hyphenate(params), type: Post)
    end

    def track_voice(params)
      request('/conversions/voice', params: hyphenate(params), type: Post)
    end
  end
end
