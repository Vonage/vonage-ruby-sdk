# frozen_string_literal: true

module Nexmo
  module UserAgent
    def self.string(app_name, app_version)
      identifiers = []
      identifiers << 'nexmo-ruby/' + VERSION
      identifiers << 'ruby/' + RUBY_VERSION
      identifiers << app_name + '/' + app_version if app_name && app_version
      identifiers.join(' ')
    end
  end
end
