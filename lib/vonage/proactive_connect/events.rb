# typed: true
# frozen_string_literal: true

module Vonage
  class ProactiveConnect::Events < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.host = :vonage_host

    # Find all events
    #
    # @example
    #   response = proactive_connect.events.list
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
    # @param [optional, String] :run_id
    #   Run IDs to filter by, if not specified, returns events for any run id
    #
    # @param [optional, String] :type
    #   Event types to filter by
    #
    # @param [optional, String] action_id
    #   Action IDs to filter by.
    #
    # @param [optional, String] :invocation_id
    #   Invocation IDs to filter by
    #
    # @param [optional, String] :recipient_id
    #   Recipient IDs to filter by
    #
    # @param [optional, String] :run_item_id
    #   Run item IDs to filter by
    #
    # @param [optional, String] src_ctx
    #   The name of the segment / matcher the item / event to filter by (exact string)
    #
    # @param [optional, String] :src_type
    #   Source types to filter by
    #
    # @param [optional, String] :trace_id
    #   Trace IDs to filter events by
    #
    # @param [optional, String] date_start
    #   ISO-8601 formatted date for when to begin events filter
    #
    # @param [optional, String] :date_end
    #   ISO-8601 formatted date for when to end events filter
    #
    # @see https://developer.vonage.com/en/api/proactive-connect#eventsFindAll
    #
    def list(**params)
      path = "/v0.1/bulk/events"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end
  end
end
