# typed: true
# frozen_string_literal: true

module Vonage
  class IdentityInsights::InsightsBuilder
    def initialize
      @insights = {}
    end

    # Add a Format insight.
    # @example
    #   builder = Vonage::IdentityInsights::InsightsBuilder.new
    #   builder.add_format
    # @return [InsightsBuilder] The InsightsBuilder instance.
    #
    def add_format
      @insights[:format] = {}
      self
    end

    # Add a Sim Swap insight.
    # @example
    #   builder = Vonage::IdentityInsights::InsightsBuilder.new
    #   builder.add_sim_swap(period: 180)
    # @param period [Integer] The period for the sim swap insight.
    #   - Optional. If provided, must be between 1 and 2400.
    # @return [InsightsBuilder] The InsightsBuilder instance.
    #
    def add_sim_swap(period: nil)
      params = {}
      if period
        validate_sim_swap_period(period)
        params[:period] = period 
      end
      @insights[:sim_swap] = params
      self
    end

    # Add a Current Carrier insight.
    # @example
    #   builder = Vonage::IdentityInsights::InsightsBuilder.new
    #   builder.add_current_carrier
    # @return [InsightsBuilder] The InsightsBuilder instance.
    #
    def add_current_carrier
      @insights[:current_carrier] = {}
      self
    end

    # Add an Original Carrier insight.
    # @example
    #   builder = Vonage::IdentityInsights::InsightsBuilder.new
    #   builder.add_original_carrier
    # @return [InsightsBuilder] The InsightsBuilder instance.
    #
    def add_original_carrier
      @insights[:original_carrier] = {}
      self
    end

    # Convert the InsightsBuilder to a Hash.
    # @return [Hash] The insights as a Hash.
    #
    def to_h
      @insights
    end

    private

    def validate_sim_swap_period(period)
      raise ArgumentError, 'Period must be an Integer' unless period.is_a?(Integer)
      raise ArgumentError, 'Period must be between 1 and 2400' unless period.between?(1, 2400)
    end
  end
end