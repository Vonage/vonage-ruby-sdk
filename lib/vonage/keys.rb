# frozen_string_literal: true

module Vonage
  module Keys

    def hyphenate(hash)
      hash.transform_keys { |k| k.to_s.tr('_', '-') }
    end

    def camelcase(hash)
      exceptions = [
        'dr_call_back_url',
        'mo_http_url',
        'mo_smpp_sys_type',
        'mo_call_back_url',
        'voice_callback_type',
        'voice_callback_value',
        'voice_status_callback',
        'messages_callback_value',
        'messages_callback_type'
      ]
      hash.transform_keys do |k|
        if exceptions.include?(k.to_s)
          next k.to_s.gsub(/_(\w)/) { $1.upcase.to_s }
        end
          k
      end
    end

    ATTRIBUTE_KEYS = Hash.new { |h, k| h[k] = k.split(PATTERN).join('_').downcase.to_sym }

    PATTERN = /[\-_]|(?<=\w)(?=[A-Z])/

    private_constant :ATTRIBUTE_KEYS

    private_constant :PATTERN

    def attribute_key(k)
      return k if k.is_a?(Symbol)

      ATTRIBUTE_KEYS[k]
    end
  end

  private_constant :Keys
end
