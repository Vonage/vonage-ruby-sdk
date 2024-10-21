# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2::TemplateFragments < Namespace
    CHANNELS = ['sms', 'voice'].freeze

    self.authentication = BearerToken

    self.request_body = JSON

    def list(template_id:, **params)
      request("/v2/verify/templates/#{template_id}/template_fragments", params: params, response_class: ListResponse)
    end

    def info(template_id:, template_fragment_id:)
      request("/v2/verify/templates/#{template_id}/template_fragments/#{template_fragment_id}")
    end

    def create(template_id:, channel:, locale:, text:)
      raise ArgumentError, "Invalid 'channel' #{channel}. Must be one of #{CHANNELS.join(', ')}" unless CHANNELS.include?(channel)
      request(
        "/v2/verify/templates/#{template_id}/template_fragments",
        params: {
          channel: channel,
          locale: locale,
          text: text
        },
        type: Post)
    end

    def update(template_id:, template_fragment_id:, text:)
      request("/v2/verify/templates/#{template_id}/template_fragments/#{template_fragment_id}", params: {text: text}, type: Patch)
    end

    def delete(template_id:, template_fragment_id:)
      request("/v2/verify/templates/#{template_id}/template_fragments/#{template_fragment_id}", type: Delete)
    end
  end
end
