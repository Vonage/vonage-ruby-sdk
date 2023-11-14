# typed: true
# frozen_string_literal: true

module Vonage
  class Meetings::Applications < Namespace
    extend T::Sig

    self.authentication = BearerToken

    self.request_body = JSON

    self.host = :vonage_host

    # Update an existing application.
    #
    # @param [required, String] :default_theme_id The id of the theme to set as application default theme
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#updateApplication
    def update(default_theme_id:)
      request("/v1/meetings/applications", params: {update_details: {default_theme_id: default_theme_id}}, type: Patch)
    end
  end
end
