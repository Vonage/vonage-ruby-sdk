# frozen_string_literal: true

module Nexmo
  module Keys # :nodoc:
    if {}.respond_to?(:transform_keys)
      def hyphenate(hash)
        hash.transform_keys { |k| hyphenate_key(k) }
      end

      def camelcase(hash)
        hash.transform_keys { |k| camelcase_key(k) }
      end
    else
      def hyphenate(hash)
        hash.each_with_object({}) { |(k, v), h| h[hyphenate_key(k)] = v }
      end

      def camelcase(hash)
        hash.each_with_object({}) { |(k, v), h| h[camelcase_key(k)] = v }
      end
    end

    def hyphenate_key(k)
      k.to_s.tr('_', '-')
    end

    def camelcase_key(k)
      k.to_s.gsub(/_(\w)/) { $1.upcase }
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
end
