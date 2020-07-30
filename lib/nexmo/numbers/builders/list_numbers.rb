# typed: ignore
# frozen_string_literal: true
require 'countries'

module Nexmo
  class Numbers::Builders::ListNumbers < Namespace
    attr_accessor :application_id, :has_application, :country, :pattern, :search_pattern, :size, :index

    def initialize(params = {})
      @application_id = params.fetch(:application_id, nil)
      @has_application = params.fetch(:has_application, nil)
      @country = params.fetch(:country, nil)
      @pattern = params.fetch(:pattern, nil)
      @search_pattern = params.fetch(:search_pattern, nil)
      @size = params.fetch(:size, nil)
      @index = params.fetch(:index, nil)

      after_initialize!(self)
    end

    def after_initialize!(builder)
      validate_params(builder)
    end

    def validate_params(builder)
      if builder.application_id
        validate_application_id_param(builder.application_id)
      end

      if builder.has_application
        validate_has_application_param(builder.has_application)
      end

      if builder.country
        validate_country_param(builder.country)
      end

      if builder.pattern
        validate_pattern_param(builder.pattern)
      end

      if builder.search_pattern
        validate_search_pattern_param(builder.search_pattern)
      end

      if builder.size
        validate_size_param(builder.size)
      end

      if builder.index
        validate_index_param(builder.index)
      end
    end

    def validate_application_id_param(application_id)
      raise ClientError.new("Expected 'application_id' parameter to be a String") unless application_id.is_a?(String)
    end

    def validate_has_application_param(has_application)
      raise ClientError.new("Expected 'has_application' parameter to be a Boolean") unless has_application.is_a?(TrueClass) || has_application.is_a?(FalseClass)
    end

    def validate_country_param(country)
      raise ClientError.new("Expected 'country' parameter to be a String") unless country.is_a?(String)

      raise ClientError.new("Expected 'country' parameter to be in ISO 3166 alpha-2 format") unless ISO3166::Country.find_country_by_alpha2(country)
    end

    def validate_pattern_param(pattern)
      raise ClientError.new("Expected 'pattern' parameter to be a String") unless pattern.is_a?(String)
    end

    def validate_search_pattern_param(search_pattern)
      raise ClientError.new("Expected 'search_pattern' parameter to be an Integer") unless search_pattern.is_a?(Integer)

      raise ClientError.new("Expected 'search_pattern' value to be one of: 0, 1, 2") unless search_pattern == 0 || search_pattern == 1 || search_pattern == 2
    end

    def validate_size_param(size)
      raise ClientError.new("Expected 'size' parameter to be an Integer") unless size.is_a?(Integer)
    end

    def validate_index_param(index)
      raise ClientError.new("Expected 'index' parameter to be an Integer") unless index.is_a?(Integer)
    end
  end
end