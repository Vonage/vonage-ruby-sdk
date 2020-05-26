# typed: strict
# frozen_string_literal: true

module Nexmo
  class Conversions < Namespace
    extend T::Sig
    include Keys

    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Nexmo::Response) }
    def track_sms(params)
      request('/conversions/sms', params: hyphenate(params), type: Post)
    end

    sig { params(params: T::Hash[Symbol, T.untyped]).returns(Nexmo::Response) }
    def track_voice(params)
      request('/conversions/voice', params: hyphenate(params), type: Post)
    end
  end
end
