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
      insights = yield insights_builder if block_given?

      validate_phone_number(phone_number)
      validate_insights(insights)

      params = {
        phone_number: phone_number,
        insights: insights.to_h
      }.merge(options)

      request('/identity-insights/v1/requests', params: params, type: Post)
    end

    def insights_builder
      InsightsBuilder.new
    end

    private

    def validate_phone_number(phone_number)
      raise ArgumentError.new("`phone_number` must be in E.164 format") unless Phonelib.parse(phone_number).valid?
    end

    def validate_insights(insights)
      raise ArgumentError.new("`insights` must be a Hash or instance of InsightsBuilder") unless insights.is_a?(Hash) || insights.is_a?(InsightsBuilder)
      raise ArgumentError.new("`insights` cannot be empty") if insights.to_h.empty?

      invalid_insights = insights.to_h.keys - VALID_INSIGHT_TYPES
      raise ArgumentError.new("`insights` contains the following invalid or unsupported insight types: #{invalid_insights.join(', ')}") unless invalid_insights.empty?
    end
  end
end
