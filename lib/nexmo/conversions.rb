# frozen_string_literal: true

module Nexmo
  class Conversions < Namespace
    def track_sms(params)
      request('/conversions/sms', params: params, type: Post)
    end

    def track_voice(params)
      request('/conversions/voice', params: params, type: Post)
    end
  end
end
