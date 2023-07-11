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
    # TODO: add auto_advance option
    #
    # @return [ListResponse]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def list
      request("/meetings/themes", response_class: ListResponse)
    end

    # Return information for specified theme.
    #
    # @param [required, String] theme_id (The id of the theme for which the info should be returned)
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def info(theme_id:)
      request("/meetings/themes/" + theme_id)
    end

    # Create a new theme.
    #
    # @param [required, String] :main_color
    #
    # @param [required, String] :brand_text
    #
    # @param [optional, String] :theme_name
    #
    # @param [optional, String] :short_company_url
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def create(main_color:, brand_text:, **params)
      request(
        "/meetings/themes",
        params: params.merge(main_color: main_color, brand_text: brand_text),
        type: Post
      )
    end

    # Update an existing theme.
    #
    # @param [optional, String] :main_color
    #
    # @param [optional, String] :brand_text
    #
    # @param [optional, String] :theme_name
    #
    # @param [optional, String] :short_company_url
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
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
    # @param [required, String] theme_id
    #
    # @param [optional, Boolean] force. Set to `true` to force delete a theme currently being used for a room, or as
    # a default theme. (Defaults to `false`)
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def delete(theme_id:, force: false)
      request(
        "/meetings/themes/" + theme_id + "?force=#{force}",
        type: Delete
      )
    end

    # Get a list of rooms that are associated with a theme id.
    #
    # @param [required, String] theme_id
    #
    # @param [optional, String] :start_id
    #
    # @param [optional, String] :end_id
    #
    # @return [Response]
    #
    # @see TODO: add docs link
    #
    # TODO: add type signature
    def list_rooms(theme_id:, **params)
      path = "/meetings/themes/" + theme_id + "/rooms"
      path += "?#{Params.encode(params)}" unless params.empty?

      request(path, response_class: Meetings::Rooms::ListResponse)
    end

    # Update an existing room.
    #
    # @param [required, String] theme_id
    #
    # TODO: add remaining params
    #
    # @return [Response]
    #
    # @see TODO: add docs link
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
