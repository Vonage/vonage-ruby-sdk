# typed: strict
# frozen_string_literal: true
require 'net/http'

module Vonage
  module HTTP
    class Options
      extend T::Sig

      sig { params(hash: T::Hash[Symbol, T.untyped]).void }
      def initialize(hash)
        raise ArgumentError, 'hash parameter cannot be empty or nil' if hash == {} || hash.nil?

        @hash = T.let(@hash, T::Hash[Symbol, T.untyped]) if defined? @hash
        @hash = hash

        @hash.each_key do |name|
          next if defined_options.key?(name)

          raise ArgumentError, "#{name.inspect} is not a valid option"
        end
      end

      sig { params(http: Net::HTTP).returns(T::Hash[Symbol, T.untyped]) }
      def set(http)
        @hash.each do |name, value|
          http.public_send(defined_options.fetch(name), value)
        end
      end

      private

      sig { returns(T::Hash[Symbol, T.untyped]) }
      def defined_options
        @defined_options = T.let(@defined_options, T.nilable(T::Hash[Symbol, T.untyped]))

        @defined_options ||= Net::HTTP.instance_methods.grep(/\w=\z/).each_with_object({}) do |name, hash|
          hash[name.to_s.chomp('=').to_sym] = name
        end
      end
    end
  end
end
