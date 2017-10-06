# frozen_string_literal: true

module Nexmo
  class CallStream < Namespace
    def start(id, params)
      request('/v1/calls/' + id + '/stream', params: params, type: Put)
    end

    def stop(id)
      request('/v1/calls/' + id + '/stream', type: Delete)
    end

    private

    def authorization_header?
      true
    end
  end
end
