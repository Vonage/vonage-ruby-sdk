# typed: strict
# frozen_string_literal: true

module Vonage
  class IdentityInsights < Namespace
    VALID_INSIGHT_TYPES = %i[format sim_swap original_carrier current_carrier].freeze
    
    self.authentication = BearerToken

    self.host = :vonage_host

    self.request_body = JSON

    # Submit an Identity Insights request.
    #  The SDK currently supports the following insight types: `format`, `sim_swap`, `current_carrier`, and `previous_carrier`.
    #
    # @example with `insights` as a Hash
    #   response = client.identity_insights.requests(phone_number: '447900000000', insights: { format: {} })
    #
    # @example with `insights` as an InsightsBuilder
    #   insights = client.identity_insights.insights_builder.add_format.add_sim_swap(period: 180)
    #   response = client.identity_insights.requests(phone_number: '447900000000', insights: insights)
    #
    # @example with a block to build `insights`
    #   response = client.identity_insights.requests(phone_number: '447900000000') do |builder|
    #     builder.add_format
    #     builder.add_sim_swap(period: 180)
    #   end
    #
    # @option params [required, String] :phone_number The phone number to request insights for, E.164 formatted.
    #
    # @option params [String] :purpose The purpose for requesting the insights.
    #
    # @option params [Hash, InsightsBuilder] :insights
    #   A Hash or InsightsBuilder instance specifying the types of insights to request.
    #   See the Vonage developer documentation for any parameters supported by each insight type.
    #
    # for block {|builder| ... }
    # @yield [builder] passes a InsightsBuilder instance to the block
    # @yieldreturn [required, InsightsBuilder] expects the block to return a InsightsBuilder instance
    #
    # @return [Vonage::Response] The API response.
    #
    # @see https://developer.vonage.com/en/api/identity-insights#getInsights
    #
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

    # Instantiate an InsightsBuilder.
    # @return [InsightsBuilder] A new InsightsBuilder instance.
    #
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
