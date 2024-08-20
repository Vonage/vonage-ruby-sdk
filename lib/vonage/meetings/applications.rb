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
    # @deprecated
    #
    # @param [required, String] :default_theme_id The id of the theme to set as application default theme
    #
    # @return [Response]
    #
    # @see https://developer.vonage.com/en/api/meetings#updateApplication
    def update(default_theme_id:)
      logger.info('This method is deprecated and will be removed in a future release.')
      request("/v1/meetings/applications", params: {update_details: {default_theme_id: default_theme_id}}, type: Patch)
    end
  end
end
