# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Lists < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    # Find all lists
    #
    # @deprecated
    #
    # @example
    #   response = proactive_connect.lists.list
    #
    # @param [optional, String] :page
    #   Page of results to jump to
    #
    # @param [optional, String] :page_size
    #   Number of results per page
    #
    # @param [optional, String] order
    #   Sort in either ascending (asc, the default) or descending (desc) order
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#listsFindAll
    #
    def list(**params)
      logger.info('This method is deprecated and will be removed in a future release.')
      path = "/v0.1/bulk/lists"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end
  end
end
