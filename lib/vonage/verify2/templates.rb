# typed: true
# frozen_string_literal: true

module Vonage
  class Verify2::Templates < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    def list(**params)
      request('/v2/verify/templates', params: params, response_class: ListResponse)
    end

    def info(template_id:)
      request('/v2/verify/templates/' + template_id)
    end

    def create(name:)
      request('/v2/verify/templates', params: { name: name }, type: Post)
    end

    def update(template_id:, **params)
      request('/v2/verify/templates/' + template_id, params: params, type: Patch)
    end

    def delete(template_id:)
      request('/v2/verify/templates/' + template_id, type: Delete)
    end
  end
end
