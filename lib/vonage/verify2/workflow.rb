# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2::Workflow
    CHANNELS = {
      sms: Verify2::Workflows::SMS,
      whatsapp: Verify2::Workflows::WhatsApp,
      whatsapp_interactive: Verify2::Workflows::WhatsAppInteractive,
      voice: Verify2::Workflows::Voice,
      email: Verify2::Workflows::Email,
      silent_auth: Verify2::Workflows::SilentAuth
    }

    CHANNELS.keys.each do |method|
      define_method method do |attributes|
        CHANNELS[method].new(**attributes)
      end
    end

    def self.method_missing(method)
      raise ClientError.new("Workflow channel must be one of the valid options. Please refer to https://developer.vonage.com/en/api/verify.v2#newRequest for a complete list.")
    end

    attr_reader :list

    def initialize
      @list = []
    end

    def <<(workflow)
      list << workflow
    end

    def hashified_list
      list.map(&:to_h)
    end
  end
end
