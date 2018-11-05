# frozen_string_literal: true
require 'cgi'

module Nexmo
  module Params # :nodoc:
    def self.encode(params)
      params.flat_map { |k, vs| Array(vs).map { |v| "#{escape(k)}=#{escape(v)}" } }.join('&')
    end

    def self.join(string, params)
      encoded = encode(params)

      return encoded if string.nil?

      string + '&' + encoded
    end

    private

    def self.escape(component)
      CGI.escape(component.to_s)
    end
  end
end
