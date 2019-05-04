# frozen_string_literal: true

module Nexmo
  class ConversationLegs < Namespace
    self.authentication = BearerToken

    def list
      request('/beta/legs')
    end

    def delete(leg_id)
      request('/beta/legs/' + leg_id, type: Delete)
    end
  end
end
