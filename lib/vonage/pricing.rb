# typed: true
# frozen_string_literal: true

module Vonage
  class Pricing < Namespace
    self.host = :rest_host

    def initialize(config, type: nil)
      raise ArgumentError if type.nil?

      @type = type

      super config
    end

    attr_reader :type

    def get(country)
      request('/account/get-pricing/outbound/' + @type, params: {country: country})
    end

    def list
      request('/account/get-full-pricing/outbound/' + @type)
    end

    def prefix(prefix)
      request('/account/get-prefix-pricing/outbound/' + @type, params: {prefix: prefix})
    end
  end
end
