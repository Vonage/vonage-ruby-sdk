# frozen_string_literal: true

module Nexmo
  module Keys
    if {}.respond_to?(:transform_keys)
      def hyphenate(hash)
        hash.transform_keys { |k| hyphenate_key(k) }
      end
    else
      def hyphenate(hash)
        hash.each_with_object({}) { |(k, v), h| h[hyphenate_key(k)] = v }
      end
    end

    def hyphenate_key(k)
      k.to_s.tr('_', '-')
    end
  end
end
