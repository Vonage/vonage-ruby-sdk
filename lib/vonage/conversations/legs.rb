# typed: true
# frozen_string_literal: true

module Vonage
  class Conversations::Legs < Namespace
    self.authentication = BearerToken

    # List legs.
    #
    # @option params [Boolean] :auto_advance
    #   Set this to `false` to not auto-advance through all the pages in the record
    #   and collect all the data. The default is `true`.     
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#listLegs
    #
    def list(params = nil, auto_advance = true)
      request('/beta/legs', params: params)
    end

    # Delete a leg.
    #
    # @param [String] leg_id
    #
    # @return [Response]
    #
    # @see https://developer.nexmo.com/api/conversation#deleteLeg
    #
    def delete(leg_id)
      request('/beta/legs/' + leg_id, type: Delete)
    end
  end
end
