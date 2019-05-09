# frozen_string_literal: true

module Nexmo
  class Applications < Namespace
    self.authentication = Basic

    self.request_body = JSON

    def create(params)
      request('/v2/applications', params: params, type: Post)
    end

    def list(params = nil)
      request('/v2/applications', params: params)
    end

    def get(id)
      request('/v2/applications/' + id)
    end

    def update(id, params)
      request('/v2/applications/' + id, params: params, type: Put)
    end

    def delete(id)
      request('/v2/applications/' + id, type: Delete)
    end
  end
end
