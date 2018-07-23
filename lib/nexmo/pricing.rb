# frozen_string_literal: true

module Nexmo
  class Pricing < Namespace
    self.host = 'rest.nexmo.com'

    def initialize(client, type: nil)
      raise ArgumentError if type.nil?

      @type = type

      super client
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
