# typed: strong
# frozen_string_literal: true

module Vonage
  module UserAgent
    extend T::Sig

    sig { params(app_name: T.nilable(String), app_version: T.nilable(String)).returns(String) }
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
