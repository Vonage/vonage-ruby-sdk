# typed: ignore
# frozen_string_literal: true

module Vonage
  module UserAgent
    def self.string(app_name, app_version)
      identifiers = []
      identifiers << 'vonage-ruby/' + VERSION
      identifiers << 'ruby/' + RUBY_VERSION
      identifiers << app_name + '/' + app_version if app_name && app_version
      identifiers.join(' ')
    end
  end

  private_constant :UserAgent
end
