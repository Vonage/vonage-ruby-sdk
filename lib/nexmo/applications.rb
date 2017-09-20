# frozen_string_literal: true

module Nexmo
  class Applications < Namespace
    def create(params)
      request('/v1/applications', params: params, type: Post)
    end

    def list(params = nil)
      request('/v1/applications', params: params)
    end

    def get(id)
      request('/v1/applications/' + id)
    end

    def update(id, params)
      request('/v1/applications/' + id, params: params, type: Put)
    end

    def delete(id)
      request('/v1/applications/' + id, type: Delete)
    end
  end
end
