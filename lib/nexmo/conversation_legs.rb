# frozen_string_literal: true

module Nexmo
  class ConversationLegs < Namespace
    self.authentication = BearerToken

    # List legs.
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/conversation#listLegs
    #
    def list
      request('/beta/legs')
    end

    # Delete a leg.
    #
    # @param [String] leg_id
    #
    # @return [Entity]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteLeg
    #
    def delete(leg_id)
      request('/beta/legs/' + leg_id, type: Delete)
    end
  end
end
