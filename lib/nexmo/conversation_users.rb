# frozen_string_literal: true

module Nexmo
  class ConversationUsers < Namespace
    self.authentication = BearerToken

    self.request_body = JSON

    def create(params)
      request('/beta/users', params: params, type: Post)
    end

    def list
      request('/beta/users')
    end

    def get(id)
      request('/beta/users/' + id)
    end

    def update(id, params)
      request('/beta/users/' + id, params: params, type: Put)
    end

    def delete(id)
      request('/beta/users/' + id, type: Delete)
    end
  end
end
