# typed: true
# frozen_string_literal: true

module Vonage
  class IdentityInsights::InsightsBuilder
    def initialize
      @insights = {}
    end

    def add_format
      @insights[:format] = {}
    end

    def add_sim_swap
      @insights[:sim_swap] = {}
    end

    def add_current_carrier
      @insights[:current_carrier] = {}
    end

    def add_previous_carrier
      @insights[:previous_carrier] = {}
    end

    def to_h
      @insights
    end
  end
end