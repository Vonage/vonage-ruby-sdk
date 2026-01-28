# typed: strict
# frozen_string_literal: true

module Vonage
  class IdentityInsights < Namespace
    VALID_INSIGHT_TYPES = %i[format sim_swap original_carrier current_carrier].freeze
    
    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_body = JSON

    # Submit an Identity Insights request.
    def requests(phone_number:, insights: {}, **options)

      raise ArgumentError.new("`phone_number` must be in E.164 format") unless Phonelib.parse(phone_number).valid?
      raise ArgumentError.new("`insights` must be a Hash or instance of InsightsBuilder") unless insights.is_a?(Hash)
      raise ArgumentError.new("`insights` cannot be empty") if insights.to_h.empty?

      invalid_insights = insights.keys - VALID_INSIGHT_TYPES
      raise ArgumentError.new("`insights` contains the following invalid or unsupported types: #{invalid_insights.join(', ')}") unless invalid_insights.empty?

      params = {
        phone_number: phone_number,
        insights: insights
      }.merge(options)

      request('/identity-insights/v1/requests', params: params, type: Post)
    end
  end
end
