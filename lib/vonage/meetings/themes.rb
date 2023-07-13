# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Themes < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :vonage_host

    # Get a list of themes associated with the Vonage application.
    #
    # @return [ListResponse]
    #
    # @see https://developer.vonage.com/en/api/meetings#getThemes
    def list
      request("/meetings/themes", response_class: ListResponse)
    end

    # Return information for specified theme.
    #
    # @param [required, String] theme_id The id of the theme for which the info should be returned
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#getThemeById
    def info(theme_id:)
      request("/meetings/themes/" + theme_id)
    end

    # Create a new theme.
    #
    # @param [required, String] :main_color
    #   The main color that will be used for the meeting room.
    #
    # @param [required, String] :brand_text
    #   The text that will appear on the meeting homepage, in the case that there is no brand image
    #
    # @param [optional, String] :theme_name
    #   The name of the theme (must be unique). If null, a UUID will automatically be generated
    #
    # @param [optional, String] :short_company_url
    #   The URL that will represent every meeting room with this theme. The value must be unique across Vonage
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#createTheme
    def create(main_color:, brand_text:, **params)
      request(
        "/meetings/themes",
        params: params.merge(main_color: main_color, brand_text: brand_text),
        type: Post
      )
    end

    # Update an existing theme.
    #
    # @param [required, String] theme_id The id of the theme to be updated
    #
    # @param [required, String] :main_color
    #   The main color that will be used for the meeting room.
    #
    # @param [required, String] :brand_text
    #   The text that will appear on the meeting homepage, in the case that there is no brand image
    #
    # @param [optional, String] :theme_name
    #   The name of the theme (must be unique). If null, a UUID will automatically be generated
    #
    # @param [optional, String] :short_company_url
    #   The URL that will represent every meeting room with this theme. The value must be unique across Vonage
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#updateTheme
    def update(theme_id:, **params)
      request(
        "/meetings/themes/" + theme_id,
        params: {
          update_details: params
        },
        type: Patch
      )
    end

    # Delete an existing theme.
    #
    # @param [required, String] :theme_id The id of the theme to be deleted
    #
    # @param [optional, Boolean] :force. Set to `true` to force delete a theme currently being used for a room, or as
    # a default theme. (Defaults to `false`)
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#deleteTheme
    def delete(theme_id:, force: false)
      request(
        "/meetings/themes/" + theme_id + "?force=#{force}",
        type: Delete
      )
    end

    # Get a list of rooms that are associated with a theme id.
    #
    # @param [required, String] theme_id THe ID of the theme to search for rooms associated with.
    #
    # @param [optional, Integer] :start_id
    #
    # @param [optional, Integer] :end_id
    #
    # @param [optional, Integer] :page_size
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#getRoomsByThemeId
    def list_rooms(theme_id:, **params)
      path = "/meetings/themes/" + theme_id + "/rooms"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: Meetings::Rooms::ListResponse)
    end

    # Set a logo for a theme.
    #
    # @param [required, String] :theme_id The ID of the theme for which the logo should be set
    #
    # @param [required, String] :filepath
    #   The filepath of the logo file. Logo files must conform to the following requirements:
    #     - Format: PNG
    #     - Maximum size: 1MB
    #     - Background must be transparent
    #     - Dimensions:
    #       - 1 px - 300 px (`white` and `colored` logos)
    #       - 16 x 16 - 32 x 32 and must be square (favicon)
    #
    # @param [required, String] :logo_type
    #   The type of logo to be set. Must be one of `white`, `colored`, `favicon`
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/meetings/guides/theme-management#uploading-icons-and-logos
    # @see https://developer.vonage.com/en/api/meetings#getUploadUrlsForTheme
    # @see https://developer.vonage.com/en/api/meetings#finalizeLogosForTheme
    #
    # TODO: add type signature
    def set_logo(theme_id:, filepath:, logo_type:)
      pn = Pathname.new(filepath)
      valid_logo_types = ['white', 'colored', 'favicon']
      raise ArgumentError, ':filepath not for a file' unless pn.file?
      raise ArgumentError, 'file at :filepath not readable' unless pn.readable?
      raise ArgumentError, "logo_type: must be one of #{valid_logo_types}" unless valid_logo_types.include?(logo_type)

      logo_upload_credentials = get_logo_upload_credentials

      filtered_logo_upload_credentials = logo_upload_credentials.select {|cred| cred.fields.logo_type == logo_type }.first

      upload_logo_file(filepath: filepath, credentials: filtered_logo_upload_credentials)

      finalize_logos(theme_id: theme_id, keys: [filtered_logo_upload_credentials.fields.key])
    end

    private

    def get_logo_upload_credentials
      request("/meetings/themes/logos-upload-urls", response_class: ListResponse)
    end

    def upload_logo_file(filepath:, credentials:)
      pn = Pathname.new(filepath)

      params = format_s3_upload_credentials(credentials)

      multipart_post_request(
        nil,
        filepath: filepath,
        file_name: pn.basename,
        mime_type: credentials.fields.content_type,
        params: params,
        override_uri: credentials.url,
        no_auth: true
      )
    end

    def finalize_logos(theme_id:, keys: [])
      request(
        "/meetings/themes/" + theme_id + "/finalizeLogos",
        params: {
          keys: keys
        },
        type: Put
      )
    end

    def format_s3_upload_credentials(credentials)
      credentials_key_map = {
        content_type: "Content-Type",
        logo_type: "logoType",
        x_amz_algorithm: "X-Amz-Algorithm",
        x_amz_credential: "X-Amz-Credential",
        x_amz_date: "X-Amz-Date",
        x_amz_security_token: "X-Amz-Security-Token",
        policy: "Policy",
        x_amz_signature: "X-Amz-Signature"
      }

      params = credentials.fields.attributes
      params.transform_keys do |k|
        if credentials_key_map.keys.include?(k)
          credentials_key_map[k]
        else
          k.to_s
        end
      end
    end
  end
end
