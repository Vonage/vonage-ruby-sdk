# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Rooms < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :meetings_host

    # Get a list of rooms associated with the Vonage application.
    #
    # @param [optional, String] :start_id
    #
    # @param [optional, String] :end_id
    #
    # TODO: add auto_advance option
    #
    # @return [ListResponse]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def list(**params)
      path = "/beta/meetings/rooms"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end

    # Return information for specified room.
    #
    # @param [required, String] room_id (The id of the room for which the info should be returned)
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def info(room_id:)
      request("/beta/meetings/rooms/" + room_id)
    end

    # Create a new room.
    #
    # @param [required, String] :display_name
    #
    # TODO: add remaining params
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def create(display_name:, **params)
      request(
        "/beta/meetings/rooms",
        params: params.merge({ display_name: display_name }),
        type: Post
      )
    end

    # Update an existing room.
    #
    # @param [required, String] room_id
    #
    # TODO: add remaining params
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def update(room_id:, **params)
      request(
        "/beta/meetings/rooms/" + room_id,
        params: {
          update_details: params
        },
        type: Patch
      )
    end
  end
end
