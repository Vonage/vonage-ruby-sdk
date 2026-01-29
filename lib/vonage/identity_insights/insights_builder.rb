# typed: true
# frozen_string_literal: true

module Vonage
  class IdentityInsights::InsightsBuilder
    def initialize
      @insights = {}
    end

    def add_format
      @insights[:format] = {}
      self
    end

    def add_sim_swap(period: nil)
      params = {}
      if period
        raise ArgumentError, 'Period must be an Integer' unless period.is_a?(Integer)
        raise ArgumentError, 'Period must be between 1 and 2400' unless period.between?(1, 2400)
        params[:period] = period 
      end
      @insights[:sim_swap] = params
      self
    end

    def add_current_carrier
      @insights[:current_carrier] = {}
      self
    end

    def add_previous_carrier
      @insights[:previous_carrier] = {}
      self
    end

    def to_h
      @insights
    end
  end
end