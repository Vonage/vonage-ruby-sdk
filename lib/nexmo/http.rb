# frozen_string_literal: true
require 'net/http'

module Nexmo
  module HTTP # :nodoc:
    class Options
      def initialize(hash)
        @hash = hash || {}

        @hash.each_key do |name|
          next if defined_options.key?(name)

          raise ArgumentError, "#{name.inspect} is not a valid option"
        end
      end

      def set(http)
        @hash.each do |name, value|
          http.public_send(defined_options.fetch(name), value)
        end
      end

      private

      def defined_options
        @defined_options ||= Net::HTTP.instance_methods.grep(/\w=\z/).each_with_object({}) do |name, hash|
          hash[name.to_s.chomp('=').to_sym] = name
        end
      end
    end
  end
end
