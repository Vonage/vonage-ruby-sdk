# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Rooms < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :vonage_host

    # Get a list of rooms associated with the Vonage application.
    #
    # @param [optional, Integer] :start_id
    #
    # @param [optional, Integer] :end_id
    #
    # @param [optional, Integer] :page_size
    #
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/meetings#getRooms
    def list(**params)
      path = "/v1/meetings/rooms"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: ListResponse)
    end

    # Return information for specified room.
    #
    # @param [required, String] room_id
    #   The id of the room for which the info should be returned
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#getRoom
    def info(room_id:)
      request("/v1/meetings/rooms/" + room_id)
    end

    # Create a new room.
    #
    # @param [required, String] :display_name
    #
    # @param [optional, String] :metadata
    #   Free text that can be attached to a room. This will be passed in the form of a header in events related to this room.
    #
    # @param [optional, String] :type
    #   The type of room. Must be one of `instant` (the default) or `long_term`.
    #
    # @param [String(date)] :expires_at
    #   The time for when the room will be expired, expressed in ISO 8601 format.
    #   The value must be greater than 10 minutes from now.
    #   Must be set if `type` is `long_term`. Should not be set if `type` is `instant`
    #
    # @param [optional, Boolean] :expire_after_use
    #   Close the room after a session ends. Only relevant for rooms where the `type` is `long_term`
    #
    # @param [optional, string(uuid)] :theme_id
    #   When specified, the meeting room will use the theme indicated by the ID.
    #
    # @param [optional, String] :join_approval_level
    #   The level of approval needed to join the meeting in the room. Must be one of: `none`, `after_owner_only`, `explicit_approval`
    #
    # @param [optional, Hash] :recording_options
    #   @option :recording_options [Boolean] :auto_record Automatically record all sessions in this room. Recording cannot be stopped when this is set to `true`.
    #   @option :recording_options [Boolean] :record_only_owner Record only the owner screen or any share screen of the video.
    #
    # @param [optional, Hash] :initial_join_options
    #   @option :initial_join_options [String] :microphone_state
    #     Set the default microphone option for users in the pre-join screen of this room.
    #     Must be one of: `on`, `off`, `default`
    #
    # @param [optional, Hash] :callback_urls Provides callback URLs to listen to events. If specified, over-rides the callback URLs specified at Application-level
    #   @option :callback_urls [String] :rooms_callback_url Callback url for rooms events
    #   @option :callback_urls [String] :sessions_callback_url Callback url for sessions events
    #   @option :callback_urls [String] :recordings_callback_url Callback url for recordings events
    #
    # @param [optional, Hash] :available_features
    #   @option :available_features [Boolean] :is_recording_available Determine if recording feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_chat_available Determine if chat feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_whiteboard_available Determine if whiteboard feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_locale_switcher_available Determine if locale switche feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_captions_available Determine if captions feature is available in the UI
    #
    # @param [optional, Hash] :ui_settings Provides options to customize the user interface
    #   @option :ui_settings [String] :language
    #     The desired language of the UI. The default is `en` (English).
    #     Must be one of: `ar`, `pt-br`, `ca`, `zh-tw`, `zh-cn`, `en`, `fr`, `de`, `he`, `it`, `es`
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#createRoom
    def create(display_name:, **params)
      request(
        "/v1/meetings/rooms",
        params: params.merge({ display_name: display_name }),
        type: Post
      )
    end

    # Update an existing room.
    # Although paramaters (other than `room_id`) are optional, at least one other parameter must be provided or an error
    #   response will be received.
    #
    # @param [required, String] room_id The ID of the Room to be updated
    #
    # @param [optional, String(date)] :expires_at
    #   The time for when the room will be expired, expressed in ISO 8601 format.
    #   Only relevant for rooms where the `type` is `long_term``
    #
    # @param [optional, Boolean] :expire_after_use
    #   Close the room after a session ends. Only relevant for rooms where the `type` is `long_term`
    #
    # @param [optional, string(uuid)] :theme_id
    #   When specified, the meeting room will use the theme indicated by the ID.
    #
    # @param [optional, String] :join_approval_level
    #   The level of approval needed to join the meeting in the room. Must be one of: `none`, `after_owner_only`, `explicit_approval`
    #
    # @param [optional, Hash] :initial_join_options
    #   @option :initial_join_options [String] :microphone_state
    #     Set the default microphone option for users in the pre-join screen of this room.
    #     Must be one of: `on`, `off`, `default`
    #
    # @param [optional, Hash] :callback_urls Provides callback URLs to listen to events. If specified, over-rides the callback URLs specified at Application-level
    #   @option :callback_urls [String] :rooms_callback_url Callback url for rooms events
    #   @option :callback_urls [String] :sessions_callback_url Callback url for sessions events
    #   @option :callback_urls [String] :recordings_callback_url Callback url for recordings events
    #
    # @param [optional, Hash] :available_features
    #   @option :available_features [Boolean] :is_recording_available Determine if recording feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_chat_available Determine if chat feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_whiteboard_available Determine if whiteboard feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_locale_switcher_available Determine if locale switche feature is available in the UI (default `true`)
    #   @option :available_features [Boolean] :is_captions_available Determine if captions feature is available in the UI
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#updateRoom
    def update(room_id:, **params)
      raise ArgumentError, 'must provide at least one other param in addition to :room_id' if params.empty?
      request(
        "/v1/meetings/rooms/" + room_id,
        params: {
          update_details: params
        },
        type: Patch
      )
    end
  end
end
