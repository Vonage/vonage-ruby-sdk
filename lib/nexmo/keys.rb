# typed: strict
# frozen_string_literal: true

module Nexmo
  module Keys
    extend T::Sig

    sig { params(hash: T::Hash[T.untyped, T.untyped]).returns(T::Hash[String, T.untyped]) }
    def hyphenate(hash)
      hash.transform_keys { |k| k.to_s.tr('_', '-') }
    end

    sig { params(hash: T::Hash[T.untyped, T.untyped]).returns(T::Hash[String, T.untyped]) }
    def camelcase(hash)
      hash.transform_keys { |k| k.to_s.gsub(/_(\w)/) { $1.upcase } }
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
