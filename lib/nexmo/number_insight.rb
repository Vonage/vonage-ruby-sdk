# frozen_string_literal: true

module Nexmo
  class NumberInsight < Namespace
    def basic(params)
      request('/ni/basic/json', params: params)
    end

    def standard(params)
      request('/ni/standard/json', params: params)
    end

    def advanced(params)
      request('/ni/advanced/json', params: params)
    end

    def advanced_async(params)
      request('/ni/advanced/async/json', params: params)
    end
  end
end
