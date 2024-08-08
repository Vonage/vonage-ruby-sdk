# typed: strict
# frozen_string_literal: true

module Vonage
  module Keys
    extend T::Sig

    sig { params(hash: T::Hash[T.untyped, T.untyped]).returns(T::Hash[String, T.untyped]) }
    def hyphenate(hash)
      hash.transform_keys { |k| k.to_s.tr('_', '-') }
    end

    sig { params(hash: T::Hash[T.untyped, T.untyped]).returns(T::Hash[T.untyped, T.untyped]) }
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
        'messages_callback_type',
        'add_stream',
        'has_audio',
        'has_video',
        'remove_stream',
        'screenshare_type',
        'session_id',
        'stream_mode',
        'archive_mode',
        'language_code',
        'max_duration',
        'partial_captions',
        'status_callback_url',
        'audio_rate',
        'phone_number',
        'hashed_phone_number',
        'max_age'
      ]
      hash.transform_keys do |k|
        if exceptions.include?(k.to_s)
          next k.to_s.gsub(/_(\w)/) { $1.upcase.to_s }
        end
          k
      end
    end

    ATTRIBUTE_KEYS = T.let(Hash.new { |h, k| h[k] = k.split(PATTERN).join('_').downcase.to_sym }, T::Hash[T.untyped, T.untyped])

    PATTERN = /[\-_]|(?<=\w)(?=[A-Z])/

    private_constant :ATTRIBUTE_KEYS

    private_constant :PATTERN

    sig { params(k: T.any(Symbol, String)).returns(Symbol) }
    def attribute_key(k)
      return k if k.is_a?(Symbol)

      ATTRIBUTE_KEYS[k]
    end
  end

  private_constant :Keys
end
