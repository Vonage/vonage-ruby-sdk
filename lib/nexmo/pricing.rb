# frozen_string_literal: true

module Nexmo
  class Pricing < Namespace
    def initialize(client, type: nil)
      raise ArgumentError if type.nil?

      @client, @type = client, type
    end

    attr_reader :type

    def get(country)
      request('/get-pricing/outbound/' + @type, params: {country: country})
    end

    def list
      request('/get-full-pricing/outbound/' + @type)
    end

    def prefix(prefix)
      request('/get-prefix-pricing/outbound/' + @type, params: {prefix: prefix})
    end

    private

    def host
      'rest.nexmo.com'
    end
  end
end
